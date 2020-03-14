#/bin/bash

#################################################################
#                                                               #
# Name: common-spam.sh                                          #
#                                                               #
# Author: Thiago Marques (thiagomarquesdums@gmail.com)          #
# Date: 26/10/19                                                #
#                                                               #
# script homologated to centOS 6 and 7                          # 
#                                                               #
# USO: /root/scripts/common-spam.sh                             #
#                                                               #
#################################################################

#ALTER VARIABLE DEFAULT IFS
IFSback=$IFS
IFS=$'\n'
LOGFILE="/var/log/exim_mainlog"
COMMONSPAMFILE="/tmp/common-spam.txt"
TMPSPAMMER="/tmp/temp_spammer.txt"
POSSIBLESPAMMER="/tmp/possible_spammer.txt"
DOMAINSPAMMER="/tmp/domain_spammer.txt"
LASTHOURCHECK="/tmp/hour_spam.txt"
SPAMMER="/tmp/spammer.txt"

#REMOVED TMP FILE SPAMMER
[ -f ${POSSIBLESPAMMER} ] && rm -f ${POSSIBLESPAMMER:-VAZIO}
[ -f ${DOMAINSPAMMER} ] && rm -f ${DOMAINSPAMMER:-VAZIO}

#GET COMMON WORDS USED IN SPAM
/usr/bin/wget https://raw.githubusercontent.com/k3rnelkill/scripts/master/find-spam/common-br.txt -O ${COMMONSPAMFILE}

#LOOP THAT WILL CYCLE THROUGH THE EXIM_MAINLOG FILE FOR KEYWORDS IDENTICAL TO THE common.spam.txt FILE
if [ -f ${LASTHOURCHECK} ]
then
	for i in $(cat ${COMMONSPAMFILE})
	do 
		grep -A 1000000 -w "$(cat ${LASTHOURCHECK})" $LOGFILE | grep -w $i | grep "<=" | awk -F\@ '{print $2}' | awk '{print $1}' 2>&1 >> ${TMPSPAMMER}
	done
else
	for i in $(cat ${COMMONSPAMFILE})
	do
		grep -w $i $LOGFILE | grep $(/bin/date +%Y-%m-%d) | grep "<=" | awk -F\@ '{print $2}' | awk '{print $1}' 2>&1 >> ${TMPSPAMMER}
	done
fi

#ORDENADREMOVED DUPLICATE LINES
cat ${TMPSPAMMER} | sort | uniq > ${POSSIBLESPAMMER}
#REMOVED TEMP FILE
[ -f ${TMPSPAMMER} ] && rm -f ${TMPSPAMMER:-VAZIO}

for x in $(cat ${POSSIBLESPAMME})
do
        grep $x /etc/userdomains
	if [ $(echo $?) -eq 0 ]
        then
                echo $x >> ${DOMAINSPAMMER}
        fi
done

#CREATE VARIABLE SPAMMER TO ZABBIX
if [ $(cat ${DOMAINSPAMMER} | wc -l) -gt 1 ]
then
        echo 1 > {$SPAMMER}
else
        echo 0 > ${SPAMMER}
fi

#SAVE TIME EXEC - COLLECT LAST EMAIL SEND
/bin/cat /var/log/exim_mainlog | grep "<=" | tail -n1 | awk '{print $1" "$2}' > ${LASTHOURCHECK}

#RETURN BACKUP IFS
IFS=$IFSback
