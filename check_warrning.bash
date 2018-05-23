# Loging and check on information about currently size memmory (VOIP) on device. This device (ICOTERA 3000) have a problem with allocated memory and it, likes hang. If return value is == 0, that script send reboot information to device by snmp

#!/usr/bin/sh

array=('10.0.0.1' '10.0.0.2' '10.0.0.3')

for i in ${array[@]}
do
        a=$(sshpass -p 12345 ssh -o ConnectTimeout=10 -o ConnectionAttempts=1 admin@$i 'show system' | awk '{ if($1 == "VoIP") { gsub(/KB/,"",$3); print $3 } }')
                if [[ "$a" -eq "0" ]];
                then	# Reboot oid
                        exec snmpset -v2c -c secret $i .1.3.6.1.4.1.29865.2.1.3.2.0 i 1
                        echo -e $a
                else
                        echo -e $a | sed 's/^[ \t]*//;s/[ \t]*$//'
                fi
done
