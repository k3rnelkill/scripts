#!/bin/bash

#DEFINES COLORS
DEFAULTCOLOR="\033[0m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"

LANGBKP=$LANG
LANG="en_US:en"
FILELOGPROCESSAMENT="/opt/hgmods/hg_processcount.log"
DAYNOW=$(/bin/date "+%b %d")
YEARNOW=$(/bin/date "+%Y")
FILEDOMAIN="/etc/trueuserdomains"
TMPFILE="/tmp/sumsend.tmp"
DIRQTDMAIL="/var/cpanel/email_send_limits/track/"

echo $DAYNOW
echo $YEARNOW
echo $LANG

#COLLECT USERS IDENTIFIED WITH HIGH CONSUMPTION.
grep -w -i "$DAYNOW" $FILELOGPROCESSAMENT | grep "$YEARNOW" | awk '{print $8}' | sed 's/(\|)//g' | sort | uniq -c | sort -nr | tee /tmp/high_processcount.txt

echo "+++++++++++++++++++++++++++++++++++++++++"

#RESTORE VARIABLE DEFAULT
LANG=$LANGBKP

for i in $(cat /tmp/high_processcount.txt | awk '{print $2}')
do      
        #COLLET DOMAIN
        DOMAIN=$(grep -w $i ${FILEDOMAIN} | awk -F\: '{print $1}')
       
       #COLLECT THE AMOUNT OF EMAILS SENT PER HOUR.
        if [ -d ${DIRQTDMAIL}${DOMAIN}/ ]
        then
                SENDERCOUNTER=$(/bin/ls -l ${DIRQTDMAIL}${DOMAIN}/ | grep $(perl -e 'print join( ".", ( gmtime(time()) )[ 3, 4, 5 ] ) ') | awk '{print $5}' > ${TMPFILE} )
        else
                echo "0" > ${TMPFILE}
        fi

        : '
           INFORMATION ABOUNT VARIABLE COUNTER AND PASTE|BC COMMAND
           -d, --delimiters=LISTA  reutiliza caracteres da LISTA em vez de tabulações
           -s, --serial            cola um arquivo por vez em de todos em paralelo

           bc this a basic calculator      
        '
        COUNTER=$(paste -sd+ ${TMPFILE} | bc)
        echo "Usuário: ${i}"
        echo "Domínio Principal: ${DOMAIN}"
        #COLLETC AMOUNT EMAILS PER USER
        echo "Número de contas de E-mail.: $(uapi --user=${i} Email list_pops | grep email | wc -l)"
        echo "Qtd de e-mails enviados: ${COUNTER}"
        echo "Número de Picos de processos: $(cat /tmp/high_processcount.txt | grep ${i} | awk '{print $1}')"
        echo "Banda em Bytes: $(whmapi1 showbw searchtype=user search=${i} | grep "totalbytes:" | sed "s/'//g" | awk '{print $2}')"
        echo "+++++++++++++++++++++++++++++++++++++++++"
done