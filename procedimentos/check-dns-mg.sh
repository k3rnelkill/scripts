#!/bin/bash

USUARIO=""
QTDSUSPEND=`egrep -rli 'internal|latam|migration' /var/cpanel/suspended/ | wc -l`
SHOWUSERS=`egrep -rli 'internal|latam|migration' /var/cpanel/suspended/ | awk -F"/" {'print $5'}`

if [ $QTDSUSPEND -gt 0 ] 
then
	echo -e "Migration located. Check supergator, please"
	sleep 2
	echo -e "Migrations completed. Users bellow."
	echo -e "$SHOWUSERS"

	read -p "Informe o usuário : " $USUARIO
	
	ORIGIN=$(ui -d "${USUARIO:-VAZIO}" | grep "NS1" | awk '{print $2}')
	DESTW=$(whois `ui -d "${USUARIO:-VAZIO}" | grep "U. Domain" | awk '{print $3}'` | grep "nserver" | tail -n1 | awk '{print $2}')
	if [ $ORIGIN != $DESTW ]
	then
		echo $ORIGIN
		echo $DESTW
		echo -e "DNS alteradas, possibilidade de remoção existente antes do prazo."
	else
		echo -e "DNS não alteradas. Remover na data."
	fi
else
	echo "None user suspended on finished."
fi
