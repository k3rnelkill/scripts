#!/bin/bash

#DEFINES COLORS
DEFAULTCOLOR="\033[0m"
GREEN="\033[1;32m"
COUNTER=0

for i in $(find /var/cpanel/suspended/ -type f -mtime +60 | grep -v 'lock$' | awk -F\/ '{print $5}')
do
        CHECKUSER=$(grep "$i" /etc/passwd)
        if [ `echo $?` -eq "0" ]
        then
                echo -e ""$GREEN"Usuário:"$DEFAULTCOLOR" $i"
                whmapi1 accountsummary user=$i | egrep "diskused:|suspendreason:"
                echo -e ""$GREEN"Data da Suspensão:"$DEFAULTCOLOR"" `date -d @$(whmapi1 accountsummary user=$i | grep suspendtime: | awk -F\' '{print $2}')`
                echo "=========================================================" 
                let COUNTER=$COUNTER+1
        else
                echo -e ""$GREEN"Usuário $i não encontrado."$DEFAULTCOLOR""
                echo "========================================================="
        fi
done
echo "Quantidade de contas suspensas: $COUNTER"
