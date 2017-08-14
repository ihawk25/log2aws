#!/bin/bash

today=$(date +%m-%d-%y)
mv /var/www/html/CommandersOrders.csv /var/www/html/PastDays/$today.csv
cp /var/www/html/PastDays/blank.csv /var/www/html/CommandersOrders.csv
rm -rf /var/www/html/bin/*
touch /var/www/html/bin/STUFF-IN-HERE-WILL-BE-DELETED

mv /var/www/html/dashbin/dashdealers.json /var/www/html/dashbin/PastDays/$today.json
cp /scripts/dash/dashdealers-blank.json /var/www/html/dashbin/dashdealers.json

