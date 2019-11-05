#/bin/bash

#################################################################
#                                                               #
# Name: common-spam.sh                                          #
#                                                               #
# Author: Thiago Marques (thiagomarquesdums@gmail.com)          #
# Date: 26/10/19                                                #
#                                                               #
# Description: search for words in exim_mainlog and send        #
# information to zabbix                                         #
#                                                               #
# script homologated to centOS 6 and 7                          # 
#                                                               #
# USO: /root/scripts/common-spam.sh                             #
#                                                               #
#################################################################

#ALTER VARIABLE DEFAULT IFS
IFSback=$IFS
IFS=$'\n'

#RESET TMP FILE SPAMMER
echo > /tmp/possible_spammer.txt
echo > /tmp/domain_spammer.txt

#GET COMMON WORDS USED IN SPAM
/usr/bin/wget https://raw.githubusercontent.com/marquesms/scripts/master/arquivos/common-spam.txt -O /tmp/common-spam.txt

#LOOP THAT WILL CYCLE THROUGH THE EXIM_MAINLOG FILE FOR KEYWORDS IDENTICAL TO THE common.spam.txt FILE
if [ -f /tmp/hour_spam.txt ]
then
	for i in $(cat /tmp/common-spam.txt)
	do 
		grep -w $i /var/log/exim_mainlog | grep -B 1000000 `cat /tmp/hour_spam.txt` | grep "<=" | awk -F\@ '{print $2}' | awk '{print $1}' 2>&1 >> /tmp/temp_spammer.txt
	done
else
	for i in $(cat /tmp/common-spam.txt)
	do
		grep -w $i /var/log/exim_mainlog | grep `/bin/date +%Y-%m-%d` | grep "<=" | awk -F\@ '{print $2}' | awk '{print $1}' 2>&1 >> /tmp/temp_spammer.txt
	done
fi

#REMOVED DUPLICATE LINES
cat /tmp/temp_spammer.txt | sort | uniq > /tmp/possible_spammer.txt
#REMOVED TEMP FILE
rm -f /tmp/temp_spammer.txt

for x in $(cat /tmp/possible_spammer.txt)
do
        grep $x /etc/userdomains
        if [ `echo $?` -eq 0 ]
        then
                echo $x >> /tmp/domain_spammer.txt
        fi
done

#CREATE VARIABLE SPAMMER TO ZABBIX
if [ `cat /tmp/domain_spammer.txt | wc -l` -gt 1 ]
then
        echo 1 > /tmp/spammer.txt
else
        echo 0 > /tmp/spammer.txt
fi

#SAVE TIME EXEC - COLLECT LAST EMAIL SEND
#/bin/date "+%Y-%m-%d %H" > /tmp/hour_spam.txt
/bin/cat /var/log/exim_mainlog | grep "<=" | awk '{print $1" "$2}' | tail -n1 > /tmp/hour_spam.txt

#RETURN BACKUP IFS
IFS=$IFSback
