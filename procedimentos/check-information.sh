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

echo "$vermelho========================================================"
echo "              Informações da Maquina                    "                  
echo "========================================================$corPadrao"

echo -e "\nQuantidade de processos: $PROCESSOS"
echo "UPTIME e LOAD: $UPTIME"

echo -e "\n====================================================="
echo    "           Informações sobre o APACHE                "
echo    "====================================================="

echo -e "\nUptime APACHE: $UPTIMEAPACHE"
echo -e "\nVersão APACHE: $APACHEVERSION"
echo -e "\nRequisições sendo processadas $APACHEPROC"
echo -e "\nProcessos ociosos $PROCOCIOSO"
