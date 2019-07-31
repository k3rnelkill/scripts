#!/bin/bash

QTDSUSPEND=`egrep -rli 'internal|latam|migration' /var/cpanel/suspended/ | wc -l`
SHOWUSERS=`egrep -rli 'internal|latam|migration' /var/cpanel/suspended/ | awk -F"/" {'print $5'}`

#COLORS
defaultColor="\033[0m"
green="\033[1;32m"
red="\033[1;31m"
blue="\033[0;34m"
yellow="\033[1;33m"

if [ $QTDSUSPEND -gt 0 ]
then
        echo -e ""$yellow"Migration located. Check supergator, please"$defaultColor""
        sleep 2
        echo -e ""$yellow"Migrations completed. Users bellow."$defaultColor""
        echo -e "$green""\n$SHOWUSERS"$defaultColor""
	echo "$blue"
        read -p "Informe the user: " USUARIO
	echo "$defaultColor"

        DNSORIGIN=$(ui -d "${USUARIO:-VAZIO}" | grep "NS2" | awk '{print $2}')
        DNSDEST=$(whois `ui -d "${USUARIO:-VAZIO}" | grep "U. Domain" | awk '{print $3}'` | grep "nserver" | tail -n1 | awk '{print $2}')
        if [ $DNSORIGIN != $DNSDEST ]
        then
                echo -e ""$green"\nDNS are already changed to the new server, possibility of removal existing before the deadline."$defaultColor""
        else
                echo -e ""$red"\nDNS não alteradas. Remover na data."$defaultColor""
        fi
else
        echo -e ""$green"\nNone user suspended on finished."$defaultColor""
fi
