#!/bin/bash

LANGBKP=$LANG
LANG="en_US:en"
FILELOGPROCESSAMENT="/opt/hgmods/hg_processcount.log"
DAYNOW=$(/bin/date "+%b %d")
YEARNOW=$(/bin/date "+%Y")

echo $DAYNOW
echo $YEARNOW
echo $LANG

grep -w -i "$DAYNOW" $FILELOGPROCESSAMENT | grep "$YEARNOW" | grep "danger" | awk '{print $8}' | sed 's/(\|)//g' | sort | uniq -c | sort -nr | tee /tmp/high_processcount.txt

echo "+++++++++++++++++++++++++++++++++++++++++"

LANG=$LANGBKP
#whmapi1 showbw searchtype=user search=alugue79
for i in $(cat /tmp/high_processcount.txt | awk '{print $2}')
do
        ec "$i" -e | grep "User sent approximately" > /tmp/email_send.txt
        echo "Usuário: $i"
        #echo "Picos de processos: $(cat /tmp/high_processcount.txt | awk '{print $1}')"
        echo "Número de contas de E-mail.: $(uapi --user=$i Email list_pops | grep email | wc -l)"
        echo "Número de Picos de processos: $(cat /tmp/high_processcount.txt | grep $i | awk '{print $1}')"
        echo "Banda em Bytes: $(whmapi1 showbw searchtype=user search=$i | grep "totalbytes:" | sed "s/'//g" | awk '{print $2}')"
        echo "Qtd de e-mails enviados: $(cat /tmp/email_send.txt | awk '{print $4}')"
        echo "+++++++++++++++++++++++++++++++++++++++++"
done

#LANG=$LANGBKP
