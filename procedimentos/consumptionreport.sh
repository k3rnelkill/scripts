#!/bin/bash

LANGBKP=$LANG
LANG="en_US:en"
FILELOGPROCESSAMENT="/opt/hgmods/hg_processcount.log"
DAYNOW=$(/bin/date "+%b %d")
YEARNOW=$(/bin/date "+%Y")

echo $DAYNOW
echo $YEARNOW
echo $LANG

grep -w -i "$DAYNOW" $FILELOGPROCESSAMENT | grep "$YEARNOW" | awk '{print $8}' | sed 's/(\|)//g' | sort | uniq -c | sort -nr | tee /tmp/high_processcount.txt

LANG=$LANGBKP
#whmapi1 showbw searchtype=user search=alugue79
for i in $(cat /tmp/high_processcount.txt | awk '{print $2}')
do
        echo "Usuário: $i"
        #echo "Picos de processos: $(cat /tmp/high_processcount.txt | awk '{print $1}')"
        echo "Picos de processos: $(cat /tmp/high_processcount.txt | grep $i | awk '{print $1}')"
        echo "Banda: $(whmapi1 showbw searchtype=user search=$i | grep "totalbytes:" | sed "s/'//g" | awk '{print $2}')"
        echo "+++++++++++++++++++++++++++++++++++++++++"
done

#LANG=$LANGBKP
