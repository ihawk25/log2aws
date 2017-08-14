#!/bin/bash

# Version 2.8.1 (IDGAF Version Jump)
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

CurrentDate=$(date +"%m-%d-%y")

Cver="281"
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
s3dir=$(echo "s3://ddsdealerlog/""$CurrentDate""/endday/""$DealerNum""-endday.log")
EOJ=$(cat /enddaysc.log | grep "NORMAL EOJ")
if [[ $EOJ != "" ]]; then
	aws s3 cp /enddaysc.log $s3dir
else
	s3dir=$(echo "s3://ddsdealerlog/""$CurrentDate""/endday/""$DealerNum""-endday.logFAIL")
	aws s3 cp /enddaysc.log $s3dir
fi

#####UPGRADE#####
s3dir=$(echo "s3://ddsdealerlog/""$CurrentDate""/upgrade/""$DealerNum""-upgrade.log")
line=$(cat /u/AGO/autoupgrade/log/autoupgrade.log | grep "Customer Version is equal or greater")
standalone=$(sed -n '2p' /u/AGO/autoupgrade/log/autoupgrade.log | grep "loadautoupg")

if [[ $standalone != "" ]];then
	notfound=$(cat /u/AGO/autoupgrade/log/autoupgrade.log | grep "gzip: autoupg.tar.z: No such file or directory")
	EOJ=$(cat /u/AGO/autoupgrade/log/autoupgrade.log | grep "NORMAL EOJ")
	if [[ $notfound != "" ]];then
		:
	else
		if [[ $EOJ != "" ]];then
			aws s3 cp /u/AGO/autoupgrade/log/autoupgrade.log $s3dir
		else
			s3dir=$(echo "s3://ddsdealerlog/""$CurrentDate""/upgrade/""$DealerNum""-upgrade.logFAIL")
			aws s3 cp /u/AGO/autoupgrade/log/autoupgrade.log $s3dir
		fi
	fi
else
	if [ "$line" == "" ];then
		EOJ=$(cat /u/AGO/autoupgrade/log/autoupgrade.log | grep "NORMAL EOJ")
		scriptcomplete=$(cat /u/AGO/autoupgrade/log/autoupgrade.log | grep "autoupgrade.sc script completed")
		if [[ $EOJ != "" && $scriptcomplete != "" ]]; then
			aws s3 cp /u/AGO/autoupgrade/log/autoupgrade.log $s3dir
		else
			s3dir=$(echo "s3://ddsdealerlog/""$CurrentDate""/upgrade/""$DealerNum""-upgrade.logFAIL")
			aws s3 cp /u/AGO/autoupgrade/log/autoupgrade.log $s3dir
		fi
	fi
fi

#####SQLBACKUP#####
SiteCount=1
while [ $SiteCount -le 100 ]; do
        CurrentSite="/u/AG$SiteCount"
        if [[ -d "$CurrentSite" ]]; then
                if [[ -e $CurrentSite/databases/sqlbackup.vbs ]]; then

                        s3dir=$(echo "s3://ddsdealerlog/""$CurrentDate""/sqlbackup/""$DealerNum""-S""$SiteCount""-sqlbackup.log")
                        s3dir_fail=$(echo "s3://ddsdealerlog/""$CurrentDate""/sqlbackup/""$DealerNum""-S""$SiteCount""-sqlbackup.logFAIL")
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

#####ARCHIVING#####
if [[ -d /u/DDS/Archive/Queue ]]; then
        Afiles=$(ls /u/DDS/Archive/Queue | wc -l)
        if [[ $Afiles -eq 0 ]]; then
                s3dir=$(echo "s3://ddsdealerlog/""$CurrentDate""/archiving/""$DealerNum""-Queue"".log")
                touch /u/DDS/scripts/archive_check
                aws s3 cp /u/DDS/scripts/archive_check $s3dir
                rm /u/DDS/scripts/archive_check
        else
                s3dir_fail=$(echo "s3://ddsdealerlog/""$CurrentDate""/archiving/""$DealerNum""-Queue"".logFAIL")
                ls -l /u/DDS/Archive/Queue > /u/DDS/scripts/archive_check
                aws s3 cp /u/DDS/scripts/archive_check $s3dir_fail
                rm /u/DDS/scripts/archive_check
        fi
fi

if [[ -d /u/DDS/Archive/QueueAR ]]; then
        Afiles=$(ls /u/DDS/Archive/QueueAR | wc -l)
        if [[ $Afiles -eq 0 ]]; then
                s3dir=$(echo "s3://ddsdealerlog/""$CurrentDate""/archiving/""$DealerNum""-QueueAR"".log")
                touch /u/DDS/scripts/archive_check
                aws s3 cp /u/DDS/scripts/archive_check $s3dir
                rm /u/DDS/scripts/archive_check
        else
                s3dir_fail=$(echo "s3://ddsdealerlog/""$CurrentDate""/archiving/""$DealerNum""-QueueAR"".logFAIL")
                ls -l /u/DDS/Archive/QueueAR > /u/DDS/scripts/archive_check
                aws s3 cp /u/DDS/scripts/archive_check $s3dir_fail
                rm /u/DDS/scripts/archive_check
        fi
fi


#####ONE-TIME COMMAND#####
echo -e "SELECT * FROM DLRFILES;\n/q;" > /u/DDS/scripts/temp.sql
chown ddsadmin:ddsadmin /u/DDS/scripts/temp.sql

su -l -c "/u/acucobol/bin/xdbcquery /cacuxdbc04://xvision:acuxdbc01.cfg /r/u/DDS/scripts/temp.sql" ddsadmin > /u/DDS/scripts/dlrfiles.txt

sed -i -e 1,7d /u/DDS/scripts/dlrfiles.txt

dlrfiles=$(awk '{printf "%s\n", $1}' /u/DDS/scripts/dlrfiles.txt | grep 2)

if [ -z "$dlrfiles" ];then
        aws s3 cp /u/DDS/scripts/dlrfiles.txt s3://ddsdealerlog/dlrfiles/$DealerNum-S
else
        aws s3 cp /u/DDS/scripts/dlrfiles.txt s3://ddsdealerlog/dlrfiles/$DealerNum-M
fi

rm /u/DDS/scripts/temp.sql
rm /u/DDS/scripts/dlrfiles.txt

#####REMOVE ONE-TIME COMMAND#####
head -n 160 /u/DDS/scripts/log2aws.sh > /u/DDS/scripts/temp
mv /u/DDS/scripts/temp /u/DDS/scripts/log2aws.sh
chown ddsadmin:ddsadmin /u/DDS/scripts/log2aws.sh
chmod 777 /u/DDS/scripts/log2aws.sh
