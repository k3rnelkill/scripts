#!/bin/bash

read -p "Senhas de e-mail serão alteradas de qual domínio? " DOMAIN
USERCOLLECT=`pwd | awk -F/ {'print $3'}`
USERDIRECTORY=`grep "$USERCOLLECT" /etc/passwd | cut -d: -f6`
EMAILPATH="$USERDIRECTORY/mail/$DOMAIN/"
USERDOMAIN=`grep "$USERCOLLECT" /etc/userdomains`
COUNTDOMAIN=`grep "$USERCOLLECT" /etc/userdomains | wc -l`

echo -e "As seguintes informações foram coletadas."
echo -e "$USERCOLLECT"
echo -e "$USERDIRECTORY"
echo -e "$EMAILPATH"

[ if `echo $COUNTDOMAIN` -gt 1 ]
then 
	echo -e "Domínios relacionados ao usuário $USERCOLLECT"
	$USERDOMAIN
fi