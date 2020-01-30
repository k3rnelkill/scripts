#!/bin/bash

##########################################################################################################################################
#                                                                                                                                        #
# Name: findserver.sh                                                                                                                    #
#                                                                                                                                        #
# Author: Thiago Marques (thiagomarquesdums@gmail.com)                                                                                   #
# Date: 20/01/20                                                                                                                         #
#                                                                                                                                        #
# Description: find and show hostname e IP server.                                                                                       #
#                                                                                                                                        #
# Use: findserver                                                                                                                        #
#                                                                                                                                        #
##########################################################################################################################################

clear

#DEFINES COLORS
DEFAULTCOLOR="\033[0m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"

#DEFINE CMD JAILSHELL
RELEASEJAILSHELL="usermod -s /usr/local/cpanel/bin/jailshell"
#DEFINE SSH PORT
SSHPORT="22022"
#VARIABLE USED TO STORE DOMAIN
read -p "Enter the domain.: " DOMAIN
#VARIABLE USED TO STORE CPANEL DNS CLUSTER
CLUSTERNAMESERVER=""
#CHECKDOMAIN IN SERVER
CHECKDOMAINIP=$(dig A cpanel.$DOMAIN $CLUSTERNAMESERVER  | grep -w "cpanel.$DOMAIN" | tail -n1 | head -1 | awk '{print $5}')

#IF VARIABLE $CHECKDOMAINIP IS NULL, DOMAIN is not found. IN CASE OF NON-NULL VARIABLE. ELSE DEIPT THIS SUSPENSION WILL BE EXECUTED...
if [ -z $CHECKDOMAINIP ]
then
        echo -e ""$RED"Variable is empty - $DOMAIN not found"$DEFAULTCOLOR""
        echo -e ""$RED"$DOMAIN not found in DNS PULL"$DEFAULTCOLOR""
else
    #COLLECT USER IN CPANEL
    COLLECTUSER=$(ssh root@$CHECKDOMAINIP -p$SSHPORT grep -w $DOMAIN /etc/trueuserdomains | awk '{print $2}')
    #COLLECT HOSTNAME
    COLLECTHOSTNAME=$(ssh root@$CHECKDOMAINIP -p$SSHPORT uname -n)

    #SHOW INFORMATION TO USER
    echo -e ""$GREEN"Show information"$DEFAULTCOLOR""
    echo -e ""$YELLOW"IP Server.:"$DEFAULTCOLOR" $CHECKDOMAINIP"
    echo -e ""$YELLOW"HOSTNAME SERVER:"$DEFAULTCOLOR" $COLLECTHOSTNAME"
    echo -e ""$YELLOW"User cPanel.:"$DEFAULTCOLOR" $COLLECTUSER"

    #RELEASE JAILSHELL TO USER INFORMED
    echo -e ""$GREEN"JAILSHELL Successfully released."$DEFAULTCOLOR""
    sleep 1
    ssh root@$CHECKDOMAINIP -p$SSHPORT $RELEASEJAILSHELL ${COLLECTUSER:-NOTFOUND}
fi
