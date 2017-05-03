#!/bin/bash

# Call: sh read_raid_battery.sh
# Output value for check_raid_battery.php
# This script read state of raid battery with dell servers , create .txt file for all hosts and saves output in hosts.txt

for i in '10.10.10.10','10.10.10.11','10.10.10.12','10.10.10.13','10.10.10.14','10.10.10.15','10.10.10.16',
		 '10.10.10.17','10.10.10.18','10.10.10.19','10.10.10.20','10.10.10.21','10.10.10.24','10.10.10.33',
		 '10.10.10.120','10.10.10.101','10.10.10.29','10.10.10.34','10.10.10.45'; do
if [ $i = "10.10.10.11" ] ; then
#ssh command for login on user raids with RSA key and grep return output
         /usr/bin/ssh -i /raid.key raids@$i -T | awk '/Status/ || /Voltage/ || /Ready/' > /usr/lib64/nagios/plugins/baterie/$i.txt
else
#for unix command /usr/local/sbin/MegaCli -AdpBbuCmd -GetBbuStatus -aALL
#for linux command /opt/MegaRAID/MegaCli/MegaCli -AdpBbuCmd -GetBbuStatus -aALL 
         /usr/bin/ssh -i /raid.key raids@$i -T | awk '/Relative/ || /Voltage:/ || /Battery State/ || /Temperature:/' > /usr/lib64/nagios/plugins/baterie/$i.txt
fi
done
echo ok $(date '+%Y %b %d %H:%M:%S')

#return:
#Voltage: 4005 mV
#Temperature: 14 C
#Battery State     : Operational
#Relative State of Charge: 95 %

#or for 10.10.10.11
#/c0/bbu BBU Ready                 = Yes
#/c0/bbu BBU Status                = OK
#/c0/bbu Battery Voltage           = OK
#/c0/bbu Battery Temperature Status= OK