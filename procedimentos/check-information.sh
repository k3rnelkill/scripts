#!/bin/bash

#################################################################
#                                                               #
# Nome: check-information.sh                                    #
#                                                               #
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)           #
# Data: 24/02/19                                                #
#                                                               #
# Descrição: Faz checagem de serviços da maquina, processo      #
# uptimes e etc.						#
# Script abaixo foi homolado para uso no CentOS 6.*		# 
#                                                               #
# USO: ./check-information.sh                                   #
#                                                               #
#################################################################

PROCESSOS=$((`ps aux | wc -l` - 1))
UPTIME=`uptime`
APACHEVERSION=`httpd -v | grep "Server version"`
UPTIMEAPACHE=`service httpd fullstatus | grep "Server uptime"`
APACHEPROC=`service httpd fullstatus | grep "currently"`
PROCOCIOSO=`service httpd fullstatus | grep "idle workers"`

#DEFININDO CORES
corPadrao="\033[0m"
vermelho="\033[0;31m"
branco="\033[1;37m"
amarelo="\033[1;33m"

echo -e "$vermelho========================================================"
echo -e "              Informações da Maquina                    "                  
echo -e "========================================================"$corPadrao""

echo -e ""$amarelo"\nQuantidade de processos:"$corPadrao" $PROCESSOS"
echo -e ""$amarelo"UPTIME e LOAD:"$corPadrao" $UPTIME"

echo -e ""$vermelho"\n====================================================="
echo -e  "           Informações sobre o APACHE                "
echo -e "====================================================="$corPadrao""

echo -e ""$amarelo"\nUptime APACHE:"$corPadrao" $UPTIMEAPACHE"
echo -e ""$amarelo"Versão APACHE:"$corPadrao" $APACHEVERSION"
echo -e ""$amarelo"Requisições sendo processadas:"$corPadrao" $APACHEPROC"
echo -e ""$amarelo"Processos ociosos:"$corPadrao" $PROCOCIOSO"
