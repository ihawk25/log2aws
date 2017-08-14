#!/bin/bash

echo -e "SELECT * FROM DLRFILES;\n/q;" > /home/ddsadmin/script.sql > /u/DDS/scripts/temp.sql
chown ddsadmin:ddsadmin /u/DDS/scripts/temp.sql

su -l -c "/u/acucobol/bin/xdbcquery /cacuxdbc04://xvision:acuxdbc01.cfg /r/home/ddsadmin/script.sql" ddsadmin > /u/DDS/scripts/dlrfiles.txt



