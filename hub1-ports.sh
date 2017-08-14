#!/bin/bash

today=$(date +%m-%d-%y)
now=$(date +%H:%M)
echo "Time = $now" >> /var/www/html/mapbin/$today.hub1-ports
cat /var/www/html/mapbin/hub1-ports.txt >> /var/www/html/mapbin/$today.hub1-ports
echo -e "\n\n" >> /var/www/html/mapbin/$today.hub1-ports

ssh ubuntu@hub1.ddslive.com 'netstat -tln |grep 172.31.32.99:5' | awk '{print $4;}' |rev|cut -c 1-5|rev|sort > /var/www/html/mapbin/hub1-ports.tmp
mv /var/www/html/mapbin/hub1-ports.tmp /var/www/html/mapbin/hub1-ports.txt

