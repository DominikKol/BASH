#!/bin/bash
# This script is using in Centos 7 -> using mysql and mail
# mail.rc configuration:
#set smtp=smtp://smtp.hostname.com:587
#set smtp-auth=login
#set smtp-auth-user=yourusername
#set smtp-auth-password=XXXXXXX
# CALL sh sendquery.sh youremailaddress 'mysql query eg. select * from xxx limit 10'
# send output mysql query to input email address

#read array
array=($@)
#remove arg[1] with array (emailaddress)
query=${array[@]/$1}
#arg[1] (emailaddress)
to=$1
#execute mysql and send output
mysql -u USERNAME -h SERVER -pPASSWORD -DdataBASE -e "$query" | mail -s "$query" $to@hostname.com
echo OK
