#!/bin/bash

# Commander script to check log2aws output
# and determine if DDS personal should be
# notified via email. Also creates csv file
# for DDS log2aws website.

# Tony Ebel
# 4/2/16
# Version 2.0.1

# Check if script is running as root
if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root!" 1>&2
        exit 1
fi


#####VARIABLES#####
today=$(date +%m-%d-%y)
#today="04-12-16"
PATH=/usr/local/bin:$PATH
export HOME=/root
output=/var/www/html/CommandersOrders.csv

aws s3 ls s3://ddsdealerlog/"$today"/endday/ | awk {'print $4;'} >> /scripts/endday
aws s3 ls s3://ddsdealerlog/"$today"/upgrade/ | awk {'print $4;'} >> /scripts/upgrade
aws s3 ls s3://ddsdealerlog/"$today"/sqlbackup/ | awk {'print $4;'} >> /scripts/sqlbackup
aws s3 ls s3://ddsdealerlog/"$today"/archiving/ | awk {'print $4;'} >> /scripts/archiving

echo '"Site","Endday","Upgrade","SQLBackup","Archiving",' > $output

while read -r line; do
	skip=$(echo $line |cut -c 1)
	if [[ $skip != "#" && $skip != "" && $skip != " " ]]; then
		outline="\"$line\","
		echo "Site: "$line
		endlog=$(cat /scripts/endday | grep "$line")
		uplog=$(cat /scripts/upgrade | grep "$line")
		sqllog=$(cat /scripts/sqlbackup | grep "$line")
		arclog=$(cat /scripts/archiving | grep "$line")
		if [[ $endlog != "" ]]; then
		        status=$(echo $endlog |rev|cut -c 1-4|rev)
		        if [[ $status != "FAIL" ]]; then
		                outline+="0,"
		        else
		                outline+="1,"
		        fi
		else
			outline+="2,"
		fi

		if [[ $uplog != "" ]]; then
		        status=$(echo $uplog |rev|cut -c 1-4|rev)
		        if [[ $status != "FAIL" ]]; then
		                outline+="0,"
		        else
		                outline+="1,"
		        fi
		else
			outline+="0,"
		fi

		if [[ $sqllog != "" ]]; then
		        status=$(echo $sqllog | grep "FAIL")
		        if [[ $status == "" ]]; then
		                outline+="0,"
		        else
		                outline+="1,"
		        fi
		else
			outline+="0,"
		fi

		if [[ $arclog != "" ]]; then
			status=$(echo $arclog |grep "FAIL")
			if [[ $status == "" ]]; then
				outline+="0"
			else
				outline+="1"
			fi
		else
			outline+="0"
		fi

		echo $outline >> $output

	fi
done < /scripts/log2aws-sites.txt

#####CLEANUP#####
rm /scripts/endday
rm /scripts/upgrade
rm /scripts/sqlbackup
rm /scripts/archiving

