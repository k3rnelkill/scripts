#!/bin/bash

MIN_UID=`grep "^UID_MIN" /etc/login.defs| tr -s "\t" | cut -f2 | tr -d "[:space:]"`
MAX_UID=`grep "^UID_MAX" /etc/login.defs| tr -s "\t" | cut -f2 | tr -d "[:space:]"`
#echo $MAX_UID
#echo $MIN_UID
OLDIFS=$IFS
IFS=$'\n'

echo -e "USUARIO\t\tUID\t\tDIRETORIO\t\tNOME OU DESCRIÇÂO"

for linha in $(cat /etc/passwd)
do
	USER_ID=`echo $linha | awk -F: '{print $3}' | tr -d "[:space:]"`
	if [ $USER_ID -ge $MIN_UID -a $USER_ID -le $MAX_UID ]
	then
		USER=`echo $linha | awk -F: '{print $1}'`
		DIRHOME=`echo $linha | awk -F: '{print $6}'`
		DESCRICAO=`echo $linha | awk -F: '{print $5}' | tr -d ',' | tr -d "[:space:]"`

		echo -e "$USER\t\t$USER_ID\t\t$DIRHOME\t\t$DESCRICAO"
	fi

done
IFS=$OLDIFS
