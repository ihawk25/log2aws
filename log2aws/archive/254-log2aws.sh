#!/bin/bash

# Version 2.5.4
# Written by Tony Ebel
# Dubuque Data Services

#Check if script is running as root
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root!" 1>&2
	exit 1
fi


#####VARIABLES#####
PATH=/home/ddsadmin/bin:$PATH

export HOME=/home/ddsadmin

DealerNum=$(hostname|cut -c 4-6)

BucketNum=$(echo "$DealerNum""01")

CurrentDate=$(date +"%m-%d-%y")

Cver="254"
Cver_pretty=$(echo $Cver|cut -c 1).$(echo $Cver|cut -c 2).$(echo $Cver|cut -c 3)
echo "########################################"
echo "#   Running log2aws.sh version $Cver_pretty   #"
echo -e "########################################\n\n"

#####CHECK FOR NEW SCRIPT#####
if [ "$1" != "--skip-upgrade" -a "$1" != "-s" -a "$1" != "-S" ]; then
        AWSver=$(aws s3 ls s3://ddsdealerlog/log2aws/ | awk '{print $NF;}' | tail -n 1 | cut -c 1-3)

        if [[ $AWSver -gt $Cver ]]; then
                echo "Newer version found!" | tee /u/DDS/scripts/log2aws-upgrade.log
                echo "Upgrading log2aws.sh from $Cver < $AWSver" | tee -a /u/DDS/scripts/log2aws-upgrade.log
                AWSupgrade="F"
                aws s3 cp s3://ddsdealerlog/log2aws/$AWSver-log2aws.sh /u/DDS/scripts/log2aws.sh && AWSupgrade="S" 2>> /u/DDS/scripts/log2aws-upgrade.log
                chmod 777 /u/DDS/scripts/log2aws.sh
                chown ddsadmin:ddsadmin /u/DDS/scripts/log2aws.sh
                ls -lh /u/DDS/scripts/log2aws.sh >> /u/DDS/scripts/log2aws-upgrade.log
                aws s3 cp /u/DDS/scripts/log2aws-upgrade.log s3://ddsdealerlog/log2aws/$AWSver-logs/$DealerNum.log-$AWSupgrade

                if [[ $AWSupgrade -eq "S" ]]; then
			echo -e "\nNew version aquired!\nRunning new version...\n" 
                        /u/DDS/scripts/log2aws.sh --skip-upgrade
                        exit 0
                fi
	else
		echo "log2aws.sh is the current version"
        fi
else
        echo "Upgrade check skipped..."
fi


#####ENDDAY#####
s3dir=$(echo "s3://ddsdealerlog/""$BucketNum""/endday/endday""$CurrentDate"".log")
EOJ=$(cat /enddaysc.log | grep "NORMAL EOJ")
if [[ $EOJ != "" ]]; then
	aws s3 cp /enddaysc.log $s3dir
else
	s3dir=$(echo "s3://ddsdealerlog/""$BucketNum""/endday/endday""$CurrentDate"".logFAIL")
	aws s3 cp /enddaysc.log $s3dir
fi

#####UPGRADE#####
s3dir=$(echo "s3://ddsdealerlog/""$BucketNum""/upgrade/upgrade""$CurrentDate"".log")
line=$(sed -n '10p' /u/AGO/autoupgrade/log/autoupgrade.log)

if [ "$line" != "Customer Version is equal or greater" ];then
	EOJ=$(cat /u/AGO/autoupgrade/log/autoupgrade.log | grep "NORMAL EOJ")
	scriptcomplete=$(cat /u/AGO/autoupgrade/log/autoupgrade.log | grep "autoupgrade.sc script completed")
	if [[ $EOJ != "" && $scriptcomplete != "" ]]; then
		aws s3 cp /u/AGO/autoupgrade/log/autoupgrade.log $s3dir
	else
		s3dir=$(echo "s3://ddsdealerlog/""$BucketNum""/upgrade/upgrade""$CurrentDate"".logFAIL")
		aws s3 cp /u/AGO/autoupgrade/log/autoupgrade.log $s3dir
	fi
fi


#####SQLBACKUP#####
SiteCount=1
while [ $SiteCount -le 100 ]; do
        CurrentSite="/u/AG$SiteCount"
        if [[ -d "$CurrentSite" ]]; then
                if [[ -e $CurrentSite/databases/sqlbackup.vbs ]]; then
                
                        s3dir=$(echo "s3://ddsdealerlog/""$BucketNum""/sqlbackup/S""$SiteCount""sqlbackup""$CurrentDate"".log")
                        s3dir_fail=$(echo "s3://ddsdealerlog/""$BucketNum""/sqlbackup/S""$SiteCount""sqlbackup""$CurrentDate"".logFAIL")
                        sql="$CurrentSite/databases/Sql-AWS$SiteCount.txt"
                        grep "db = " $CurrentSite/databases/sqlbackup.vbs |rev|cut -c 3- |rev|cut -c 7- > $sql
                        SQLcount=$(cat $sql |wc -l)
                        BUPcount=$(find $CurrentSite/databases/ -mtime -1 -name "*.bak" |wc -l)

                        if [ $BUPcount -lt $SQLcount ]
                        then
                                echo -e "\nAt least one backup has not been created in the past 12 hours.\n----------" >> $sql
                                ls -lR $CurrentSite/databases/ >> $sql
                                aws s3 cp $sql $s3dir_fail
                        else
                                echo "Backups have ran in the last 12 hours." >> $sql
                                aws s3 cp $sql $s3dir
                        fi
                        mv $sql $sql.uploaded
                        chmod 666 $sql.uploaded
                        chown ddsadmin:ddsadmin $sql.uploaded

                fi
        fi
        SiteCount=$(expr $SiteCount + 1)
done

