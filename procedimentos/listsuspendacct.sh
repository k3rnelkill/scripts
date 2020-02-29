#!/bin/bash

for i in $(ls -1 /var/cpanel/suspended/ | grep -v 'lock$' | sed '/\./d') 
do 
    whmapi1 accountsummary user=$i | egrep "user:|diskused:|suspendreason:" ; 
    echo  "      Suspension date: $(whmapi1 accountsummary user=$i | grep suspendtime: | awk -F\' '{print $2}' | xargs -i date -d @"{}")"
    echo "========================================================="
done
