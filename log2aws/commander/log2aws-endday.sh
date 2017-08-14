#!/bin/bash

today=$(date +%m-%d-%y)
mv /var/www/html/CommandersOrders.csv /var/www/html/PastDays/$today.csv
cp /var/www/html/PastDays/blank.csv /var/www/html/CommandersOrders.csv

