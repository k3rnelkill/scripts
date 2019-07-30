#!/bin/bash

QTDSUSPEND=`egrep -rli 'internal|latam|migration' /var/cpanel/suspended/ | wc -l`
SHOWUSERS=`egrep -rli 'internal|latam|migration' /var/cpanel/suspended/ | awk -F"/" {'print $5'}`

if [ $QTDSUSPEND -gt 0 ] 
then
	echo -e "Migration located. Check supergator, please"
	sleep 2
	echo -e "Account fining"
	echo -e "$SHOWUSERS"
else
	echo "None user suspended on finding"
fi


