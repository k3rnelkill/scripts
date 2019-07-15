#!/bin/bash

#DEFINE COLORS
corPadrao="\033[0m"
verde="\033[1;32m"
vermelho="\033[1;31m"
branco="\033[1;37m"
amarelo="\033[1;33m"

USERCOLLECT=`pwd | awk -F/ {'print $3'}`
PASS=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n1`
USERDIRECTORY=`grep "$USERCOLLECT" /etc/passwd | cut -d: -f6`
DOMAIN=`grep "$USERCOLLECT" /etc/trueuserdomains | awk '{print $1}' | sed 's/\://'`
EMAILPATH="$USERDIRECTORY/mail/$DOMAIN/"
USERDOMAIN=`grep "$USERCOLLECT" /etc/userdomains`
COUNTDOMAIN=`grep "$USERCOLLECT" /etc/userdomains | wc -l`

echo -e ""$vermelho"Informações coletadas."$corPadrao""
echo -e ""$vermelho"Usuário: "$amarelo"$USERCOLLECT"$corPadrao""
echo -e ""$vermelho"Path "$amarelo"$USERDIRECTORY"$corPadrao""

if [ `echo $COUNTDOMAIN` -gt 1 ]
then 
	echo -e ""$vermelho"Domínios: "$corPadrao""
	echo -e ""$amarelo"$USERDOMAIN"$corPadrao""
	echo -e "================================"
	echo -e ""$vermelho"Senhas de e-mail serão alteradas para qual domínio?"$corPadrao""
	read -p "--> " DOMAIN
	EMAILPATH="$USERDIRECTORY/mail/$DOMAIN/"
	echo -e ""$vermelho"Domínio selecionado: "$amarelo"$DOMAIN""$corPadrao"
	echo -e ""$vermelho"Path EMAIL: "$amarelo"$EMAILPATH""$corPadrao"
	echo -e "================================"
	sleep 3
	ls -1 $EMAILPATH | sed 's/\///' | sed 's/^\.*//' | sed '/^$/d'
	for CONTAS in $(ls -1 $EMAILPATH | sed 's/\///' | sed 's/^\.*//' | sed '/^$/d'); do uapi --user="$USERCOLLECT" Email passwd_pop email="$CONTAS" password="$PASS" domain="$DOMAIN"; done
else
	echo -e "================================"
	echo -e ""$vermelho"Domínio selecionado: "$amarelo"$DOMAIN""$corPadrao"
	echo -e ""$vermelho"Path EMAIL: "$amarelo"$EMAILPATH""$corPadrao"
	echo -e "================================" 
	sleep 3
	ls -1 $EMAILPATH | sed 's/\///' | sed 's/^\.*//' | sed '/^$/d'
	for CONTAS in $(ls -1 $EMAILPATH | sed 's/\///' | sed 's/^\.*//' | sed '/^$/d'); do uapi --user="$USERCOLLECT" Email passwd_pop email="$CONTAS" password="$PASS" domain="$DOMAIN"; done
fi
