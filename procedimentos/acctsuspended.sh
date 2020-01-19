#!/bin/bash

#DEFININDO CORES
defaultColor="\033[0m"
verde="\033[1;32m"
RED="\033[1;31m"
branco="\033[1;37m"
amarelo="\033[1;33m"

read -p "Informe o Domínio.: " DOMINIO
CLUSTERNAMESERVER="DNS NAMESERVER HERE"
CMDSUSPEND="/scripts/suspendacct"
CMDUNSUPEND="/scripts/unsuspendacct"
CHECKDOMAINIP=$(dig A cpanel.$DOMINIO $CLUSTERNAMESERVER  | grep -w "cpanel.$DOMINIO" | tail -n1 | head -1 | awk '{print $5}')
COLLECTUSER=$(ssh root@$CHECKDOMAINIP -p22022 grep -w $DOMINIO /etc/trueuserdomains | awk '{print $2}')

echo $DOMINIO

if [ -z $CHECKDOMAINIP ]
then

	echo "Entrou no if NULO"

	echo -e ""$RED"Variable is empty - Domain not found"$defaultColor""
	echo -e ""$RED"Domínio não encontrado no pull de DNS"$defaultColor""
else

	echo "Entrou no else, dados validos"
	echo "Domain.: $DOMINIO"
	echo "IP Server.: $CHECKDOMAINIP"
	echo "User cPanel.: $COLLECTUSER"
	
	ssh root@$CHECKDOMAINIP -p22022 $CMDSUSPEND $COLLECTUSER \"FINANCEIRO\" 1

fi
