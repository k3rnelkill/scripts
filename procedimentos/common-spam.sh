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
#USE THIS LINE TO SEARCH ON A SPECIFIC DATE
#for i in $(cat /tmp/common-spam.txt); do grep -w $i /var/log/exim_mainlog | grep 2019-10-23; done
#for i in $(cat /tmp/common-spam.txt); do grep -w $i /var/log/exim_mainlog | grep `/bin/date +%Y-%m-%d` | grep "<=" | awk -F\@ '{print $2}' | awk '{print $1}' | tee -a /tmp/temp_spammer.txt; done
for i in $(cat /tmp/common-spam.txt); do grep -w $i /var/log/exim_mainlog | grep "2019-10-30" | grep "<=" | awk -F\@ '{print $2}' | awk '{print $1}' | tee -a /tmp/temp_spammer.txt; done

#REMOVED DUPLICATE LINES
cat /tmp/temp_spammer.txt | sort | uniq > /tmp/possible_spammer.txt
#REMOVED TEMP FILE
rm -f /tmp/temp_spammer.txt

#for i in $(cat /tmp/domain_spammer.txt); do grep $i /etc/userdomain ; echo $? ; done
for x in $(cat /tmp/possible_spammer.txt)
do
	grep $x /etc/userdomain
	if [ `echo $?` -eq 0 ]
	then
		echo $x >> /tmp/domain_spammer.txt
	fi
done


#RETURN BACKUP IFS
IFS=$IFSback
