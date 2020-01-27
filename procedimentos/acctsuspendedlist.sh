#!/bin/bash

##########################################################################################################################################
#                                                                                                                                        #
# Name: acctsuspendedlist.sh                                                                                                           	 #
#                                                                                                                                        #
# Author: Thiago Marques (thiagomarquesdums@gmail.com)                                                                                   #
# Date: 26/01/20                                                                                                                         #
#                                                                                                                                        #
# Description: script finds the server and suspends it.                                                                     		     #
#                                                                                                                                        #
# Use: acctsuspendedlist															                                                     #
#                                                                                                                                        #
##########################################################################################################################################

#DEFINES COLORS
DEFAULTCOLOR="\033[0m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"

#DEFINE SSH PORT
SSHPORT="22022"
#DEFINY DNS CLUSTER
#CLUSTERNAMESERVER="CLUSTER DNS HERE"
CLUSTERNAMESERVER="ns4.datatop.com.br"
#SCRIPT TO SUSPENSION
CMDSUSPEND="/scripts/suspendacct"
FILESUSPENDED="/tmp/suspended.txt"

#CHECK FILE EXIST AND NOT BLANK
if [ -s $FILESUSPENDED ]
then
    for DOMAIN in  $(sed -e 's/\,/\n/g' $FILESUSPENDED)
    do 
	#VERIFY DOMAIN RESOLV DNS AND EXIST POINTER CPANEL
        CHECKDOMAINIP=$(dig A cpanel.$DOMAIN $CLUSTERNAMESERVER  | grep -w "cpanel.$DOMAIN" | tail -n1 | head -1 | awk '{print $5}')
        if [ -z $CHECKDOMAINIP ]
        then
	        echo -e ""$RED"Variable is empty - $DOMAIN not found"$DEFAULTCOLOR""
	        echo -e ""$RED"$DOMAIN not found in DNS PULL"$DEFAULTCOLOR""
            echo -e ""$BLUE"+++++++++++++++++++++++++++++++++++++++++++++++++++++++"$DEFAULTCOLOR""
        else
            #COLLECT USER IN CPANEL
            COLLECTUSER=$(ssh root@$CHECKDOMAINIP -p$SSHPORT grep -w $DOMAIN /etc/trueuserdomains | awk '{print $2}')
            #COLLECT HOSTNAME
            COLLECTHOSTNAME=$(ssh root@$CHECKDOMAINIP -p$SSHPORT uname -n)
            #SHOW INFORMATION TO USER
            echo -e ""$GREEN"Show information"$DEFAULTCOLOR""
            echo -e ""$YELLOW"Domain.:"$DEFAULTCOLOR" $DOMAIN"
            echo -e ""$YELLOW"IP Server.:"$DEFAULTCOLOR" $CHECKDOMAINIP"
            echo -e ""$YELLOW"HOSTNAME SERVER:"$DEFAULTCOLOR" $COLLECTHOSTNAME"
            echo -e ""$YELLOW"User cPanel.:"$DEFAULTCOLOR" $COLLECTUSER"	
            #SUSPENSION COMMANDS WILL BE PASSED THROUGH REMOTE SSH	
            #ssh root@$CHECKDOMAINIP -p$SSHPORT $CMDSUSPEND $COLLECTUSER \"FINANCEIRO\" 1
            echo -e ""$BLUE"+++++++++++++++++++++++++++++++++++++++++++++++++++++++"$DEFAULTCOLOR""
        fi
    done
    #REMOVE FILE WITH LIST OF ACCOUNTS.
    echo -e ""$RED"REMOVE FILE TEMP"$DEFAULTCOLOR""
    #rm -fv ${FILESUSPENDED:-NOTFOUND}
else
    echo -e ""$RED"Create a /tmp/suspended.txt file with the domains to be suspended separated by commas.."$DEFAULTCOLOR""
    echo -e "+++++++++++++"$RED"CRIE A LISTA BIZONHO!!!"$DEFAULTCOLOR"++++++++++++++"
fi
