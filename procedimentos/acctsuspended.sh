#!/bin/bash

##########################################################################################################################################
#                                                                                                                                        #
# Name: acctsysoebded.sh                                                                                                           		 #
#                                                                                                                                        #
# Author: Thiago Marques (thiagomarquesdums@gmail.com)                                                                                   #
# Date: 20/01/20                                                                                                                         #
#                                                                                                                                        #
# Description: script finds the server and suspends it.                                                                     			 #
#                                                                                                                                        #
# Use: acctsysoebded																										             #
#                                                                                                                                        #
##########################################################################################################################################

#DEFINES COLORS
DEFAULTCOLOR="\033[0m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"

#DEFINY SSH PORT
SSHPORT="22022"
#VARIABLE USED TO STORE DOMAIN
read -p "Enter the domain.: " DOMAIN
#VARIABLE USED TO STORE CPANEL DNS CLUSTER
CLUSTERNAMESERVER="CLUSTER DNS HERE"
#SCRIPT TO SUSPENSION
CMDSUSPEND="/scripts/suspendacct"
#CHECKDOMAIN IN SERVER
CHECKDOMAINIP=$(dig A cpanel.$DOMAIN $CLUSTERNAMESERVER  | grep -w "cpanel.$DOMAIN" | tail -n1 | head -1 | awk '{print $5}')
#COLLECT USER IN CPANEL
COLLECTUSER=$(ssh root@$CHECKDOMAINIP -p$SSHPORT grep -w $DOMAIN /etc/trueuserdomains | awk '{print $2}')
#COLLECT HOSTNAME
COLLECTHOSTNAME=$(ssh root@$CHECKDOMAINIP -p$SSHPORT uname -n)

#TEST VARIABLE
#echo $DOMAIN

#IF VARIABLE $CHECKDOMAINIP IS NULL, DOMAIN is not found. IN CASE OF NON-NULL VARIABLE. ELSE DEIPT THIS SUSPENSION WILL BE EXECUTED...
if [ -z $CHECKDOMAINIP ]
then
	#echo "Entrou no if NULO"
	echo -e ""$RED"Variable is empty - $DOMAIN not found"$DEFAULTCOLOR""
	echo -e ""$RED"$DOMAIN not found in DNS PULL"$DEFAULTCOLOR""
else
	#echo "Entrou no else, dados validos"
	echo -e ""$YELLOW"Domain.:"$DEFAULTCOLOR" $DOMAIN"
	echo -e ""$YELLOW"IP Server.:"$DEFAULTCOLOR" $CHECKDOMAINIP"
	echo -e ""$YELLOW"HOSTNAME SERVER:"$DEFAULTCOLOR" $COLLECTHOSTNAME"
	echo -e ""$YELLOW"User cPanel.:"$DEFAULTCOLOR" $COLLECTUSER"
	#SUSPENSION COMMANDS WILL BE PASSED THROUGH REMOTE SSH	
	ssh root@$CHECKDOMAINIP -p$SSHPORT $CMDSUSPEND $COLLECTUSER \"FINANCEIRO\" 1
fi