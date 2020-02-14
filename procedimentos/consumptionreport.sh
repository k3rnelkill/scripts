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

echo $DAYNOW
echo $YEARNOW
echo $LANG

grep -w -i "$DAYNOW" $FILELOGPROCESSAMENT | grep "$YEARNOW" | awk '{print $8}' | sed 's/(\|)//g' | sort | uniq -c | sort -nr | tee /tmp/high_processcount.txt

echo "+++++++++++++++++++++++++++++++++++++++++"

LANG=$LANGBKP

for i in $(cat /tmp/high_processcount.txt | awk '{print $2}')
do
        DOMAIN=$(grep -w $i /etc/trueuserdomains | awk -F\: '{print $1}')
       
        #SENDERCOUNTER=$(/bin/ls -l /var/cpanel/email_send_limits/track/${DOMAIN}/ | grep ${DAYNOW}| awk '{print $5}' | egrep -v '(4096|36864)' | sed '/^$/d' > ${TMPFILE})
        SENDERCOUNTER=$(/bin/ls -l /var/cpanel/email_send_limits/track/${DOMAIN}/ | grep $(perl -e 'print join( ".", ( gmtime(time()) )[ 3, 4, 5 ] ) ') | awk '{print $5}' > ${TMPFILE} )
        : '
           INFORMATION ABOUNT VARIABLE COUNTER AND PASTE|BC COMMAND
           -d, --delimiters=LISTA  reutiliza caracteres da LISTA em vez de tabulações
           -s, --serial            cola um arquivo por vez em de todos em paralelo

           bc this a basic calculator      
        '
        COUNTER=$(paste -sd+ ${TMPFILE} | bc)
        echo "Usuário: ${i}"
        echo "Domínio Principal: ${DOMAIN}"
        echo "Número de contas de E-mail.: $(uapi --user=${i} Email list_pops | grep email | wc -l)"
        echo "Qtd de e-mails enviados: ${COUNTER}"
        echo "Número de Picos de processos: $(cat /tmp/high_processcount.txt | grep ${i} | awk '{print $1}')"
        echo "Banda em Bytes: $(whmapi1 showbw searchtype=user search=${i} | grep "totalbytes:" | sed "s/'//g" | awk '{print $2}')"
        echo "+++++++++++++++++++++++++++++++++++++++++"
done

#LANG=$LANGBKP