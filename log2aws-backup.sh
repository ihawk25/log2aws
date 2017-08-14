#!/bin/bash

/usr/local/bin/aws s3 cp s3://ddsdealerlog/backup-ip.txt /scripts/backup-ip.txt
backupip=$(cat /scripts/backup-ip.txt)
echo "Backup IP is: $backupip"

rsync -avr -e "ssh -p 9000" --include=/var/ --include=/var/www/ --include=/var/www/html/ --include=/var/www/html/* \
--exclude=/bin/ --exclude=/boot/ --exclude=/dev/ --exclude=/etc/ --exclude=/home/ --exclude=/lib/ --exclude=/lost+found/    \
--exclude=/media/ --exclude=/mnt/ --exclude=/opt/ --exclude=/proc/ --exclude=/root/ --exclude=/run/ --exclude=/sbin/        \
--exclude=/srv/ --exclude=/sys/ --exclude=/tmp/ --exclude=/usr/ --exclude=/var/*                                            \
/ root@$backupip://backup/

