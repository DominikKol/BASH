#!/usr/bin/bash
command="/usr/bin/php /var/www/html/servers/servers/check_server_temp.php"

# PHP output example: 30 (only digit)

gawk="/usr/bin/gawk"
rrdtool="/usr/bin/rrdtool"
host=('xxx.xxx.xxx.xxx' 'yyy.yyy.yyy.yyy' 'zzz.zzz.zzz.zzz')


get_data() {
    local output=$($command $1 2>&1)
    local method=$(echo "$output" | head -n1 | awk '{print $1;}')
    RETURN_DATA=$method
}

cd /var/www/html/servers/servers

step = 1
for i in ${host[@]} ; do

((++step))

get_data $i

echo "$rrdtool update $step-temp.rrd --template ds0:ds1 N:$RETURN_DATA:$RETURN_DATA"
$rrdtool update $step-temp.rrd --template ds0:ds1 N:$RETURN_DATA:$RETURN_DATA

done
