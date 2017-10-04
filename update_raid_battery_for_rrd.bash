#!/usr/bin/bash
command="/usr/bin/php /usr/lib64/nagios/plugins/check_raid_battery_for_rrd.php"

### PHP output example: 1 30 44 89 where 0-1 act status, temperature, voltage (float : 4.01 etc), charging % (all only digit)

gawk="/usr/bin/gawk"
rrdtool="/usr/bin/rrdtool"
host=('xxx.xxx.xxx.xxx' 'yyy.yyy.yyy.yyy' 'zzz.zzz.zzz.zzz')

get_data() {
    local output_oper=$($command $1 $2 2>&1)

    local output_param=$($command $1 $3 2>&1)

    local method=(`echo "$output_oper" "$output_param"`)

    RETURN_DATA1=${method[0]}

    RETURN_DATA2=${method[1]}

    RETURN_DATA3=${method[2]}

    RETURN_DATA4=${method[3]}
}

cd /var/www/html/servers/raid

step = 1
for i in ${host[@]} ; do

((++step))

get_data $i "operational" "parameters"

#echo $RETURN_DATA

echo "$rrdtool update $step-raid.rrd --template ds0:ds1:ds2:ds3 N:$RETURN_DATA1:$RETURN_DATA2:$RETURN_DATA3:$RETURN_DATA4"

$rrdtool update $step-raid.rrd --template ds0:ds1:ds2:ds3 N:$RETURN_DATA1:$RETURN_DATA2:$RETURN_DATA3:$RETURN_DATA4

done


### Before this code create round robin databases :

# for i in {1..6};  do
#       rrdtool create /var/www/html/servers/raid/$i-raid.rrd --start `date +%s` --step 300 DS:ds0:GAUGE:600:-100:100 DS:ds1:GAUGE:600:-100:100 DS:ds2:GAUGE:600:-100:100 DS:ds3:GAUGE:600:-100:100 RRA:AVERAGE:0.5:1:288 RRA:AVERAGE:0.5:3:672 RRA:AVERAGE:0.5:12:744 RRA:AVERAGE:0.5:72:1480
# done
