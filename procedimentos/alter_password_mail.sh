#!/bin/bash

##########################################################################################################################################
#                                                                                                                                        #
# Name: alter_password_mail.sh                                                                                                           #
#                                                                                                                                        #
# Author: Thiago Marques (thiagomarquesdums@gmail.com)                                                                                   #
# Date: 17/07/19                                                                                                                         #
#                                                                                                                                        #
# Description: Used to change the password for the email account.                                                                        #
#                                                                                                                                        #
# Use: bash <(curl -ks https://raw.githubusercontent.com/marquesms/scripts/master/procedimentos/alter_password_mail.sh)                  #
#                                                                                                                                        #
##########################################################################################################################################

#DEFINE COLORS
corPadrao="\033[0m"
verde="\033[1;32m"
vermelho="\033[1;31m"
branco="\033[1;37m"
amarelo="\033[1;33m"

echo -e ""$vermelho"PLEASE, Execute in USER PATH!"$corPadrao""

sleep 5

echo -e ""$vermelho"STARTING ... "$corPadrao""

#Collect user cPanel
USERCOLLECT=`pwd | awk -F/ {'print $3'}`
#Collect path cPanel user
USERDIRECTORY=`grep "$USERCOLLECT" /etc/passwd | cut -d: -f6`
#Collect Sellect domain
DOMAIN=`grep "$USERCOLLECT" /etc/trueuserdomains | awk '{print $1}' | sed 's/\://'`
#Collect e-mail path
EMAILPATH="$USERDIRECTORY/mail/$DOMAIN/"
#Collect user domains
USERDOMAIN=`grep "$USERCOLLECT" /etc/userdomains`
#Count the amount of domain. 
COUNTDOMAIN=`grep "$USERCOLLECT" /etc/userdomains | wc -l`

#Show collected information
echo -e ""$vermelho"Informações coletadas."$corPadrao""
echo -e ""$vermelho"Usuário: "$amarelo"$USERCOLLECT"$corPadrao""
echo -e ""$vermelho"Path "$amarelo"$USERDIRECTORY"$corPadrao""

#Identifying the existence of more than one domain
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
	#ls -1 $EMAILPATH | sed 's/\///' | sed 's/^\.*//' | sed '/^$/d'
	#ls collect e-mail account, loop it will scroll through the list of email accounts collected through ls
	for CONTAS in $(ls -1 $EMAILPATH | sed 's/\///' | sed 's/^\.*//' | sed '/^$/d')
       	do
       	#Create temporary password and send file passtemp
		/bin/cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n1 > /tmp/passtemp.txt
		echo -e "================================"
		#Printing password
		echo -e "\n"$vermelho"Usuário:"$corPadrao" "$CONTAS" "$vermelho"Senha:"$corPadrao" `cat /tmp/passtemp.txt`" 
		#
		/usr/bin/uapi --user="$USERCOLLECT" Email passwd_pop email="$CONTAS" password=`cat /tmp/passtemp.txt` domain="$DOMAIN" 2>&1> /tmp/alter_pass.txt
		echo -e "================================"
	done
#will change the password of the unique account	
else
	echo -e "================================"
	echo -e ""$vermelho"Domínio selecionado: "$amarelo"$DOMAIN""$corPadrao"
	echo -e ""$vermelho"Path EMAIL: "$amarelo"$EMAILPATH""$corPadrao"
	echo -e "================================" 
	sleep 3
	#ls -1 $EMAILPATH | sed 's/\///' | sed 's/^\.*//' | sed '/^$/d'
	for CONTAS in $(ls -1 $EMAILPATH | sed 's/\///' | sed 's/^\.*//' | sed '/^$/d')
       	do 
		/bin/cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n1 > /tmp/passtemp.txt
		echo -e "================================"
		echo -e "\n"$vermelho"Usuário:"$corPadrao" "$CONTAS" "$vermelho"Senha:"$corPadrao" `cat /tmp/passtemp.txt`" 
		/usr/bin/uapi --user="$USERCOLLECT" Email passwd_pop email="$CONTAS" password=`cat /tmp/passtemp.txt` domain="$DOMAIN" 2>&1> /tmp/alter_pass.txt
		echo -e "================================"
	done
fi
