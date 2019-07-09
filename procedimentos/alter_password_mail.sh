#!/bin/bash

USERCOLLECT=`pwd | awk -F/ {'print $3'}`
USERDIRECTORY=`grep "$USERCOLLECT" /etc/passwd | cut -d: -f6`
EMAILPATH="$USERDIRECTORY/mail/$DOMAIN/"
USERDOMAIN=`grep "$USERCOLLECT" /etc/userdomains`
COUNTDOMAIN=`grep "$USERCOLLECT" /etc/userdomains | wc -l`

echo -e "As seguintes informações foram coletadas."
echo -e "Usuário: $USERCOLLECT"
echo -e "Path $USERDIRECTORY"
echo -e "Email Path $EMAILPATH"

if [ `$COUNTDOMAIN` -gt 1 ]
then 
	echo -e "Domínios $USERCOLLECT relacionados ao usuário"
	$USERDOMAIN
	read -p "Senhas de e-mail serão alteradas para qual domínio? " DOMAIN
	echo -e "Domínio selecionado $DOMAIN"
fi
