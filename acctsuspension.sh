#!/bin/bash

#DEFINES COLORS
DEFAULTCOLOR="\033[0m"
GREEN="\033[1;32m"

for i in $(ls -1 /var/cpanel/suspended/ | grep -v 'lock$' | sed '/\./d')
do 
 	echo -e ""$GREEN"Usuário:"$DEFAULTCOLOR" $i"
	whmapi1 accountsummary user=$i | egrep "diskused:|suspendreason:"
	echo -e ""$GREEN"Data da Suspensão:"$DEFAULTCOLOR"" `date -d @$(whmapi1 accountsummary user=$i | grep suspendtime: | awk -F\' '{print $2}')`
	echo "=========================================================" 
done
