#!/bin/bash

echo "Pi will REBOOT in five minutes..." | wall
sleep 3m
echo "Pi will REBOOT in two minutes..." | wall
sleep 1m
echo 'FINAL WARNING: Pi will REBOOT in one minute!!!' | wall
sleep 1m
/sbin/reboot now

