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
#UPTIMEAPACHE=`service httpd fullstatus | grep "Server uptime"`
APACHEINFO=`service httpd fullstatus | head -n20`
APACHEPROC=`service httpd fullstatus | grep "currently"`
PROCOCIOSO=`service httpd fullstatus | grep "idle workers"`
MEMORIATOTAL=`free -h | grep "Mem" | awk {'print $2'}`
MEMORIALIVRE=`free -h | grep "Mem" | awk {'print $4'}`
QTDCPU=`cat /proc/cpuinfo | grep "processor" | wc -l`
MODELCPU=`cat /proc/cpuinfo | grep "model name" | tail -n1 | awk -F: {'print $2'}`
DISCO=`df -kh | egrep -v '(tmpfs|udev|none)'`


#DEFININDO CORES
corPadrao="\033[0m"
vermelho="\033[1;31m"
branco="\033[1;37m"
amarelo="\033[1;33m"

echo -e "$vermelho========================================================"
echo -e "              Informações de Hardware                    "                  
echo -e "========================================================"$corPadrao""

echo -e ""$amarelo"Qtd de memória total:"$corPadrao" $MEMORIATOTAL"
echo -e ""$amarelo"Qtd de CPU:"$corPadrao" $QTDCPU"
echo -e ""$amarelo"Modelo CPU:"$corPadrao"$MODELCPU"
echo -e "\n"$amarelo"Partições:"
echo -e ""$corPadrao"$DISCO"

echo -e "\n$vermelho========================================================"
echo -e "              Informações de uso                    "
echo -e "========================================================"$corPadrao""

echo -e ""$amarelo"Qtd de memória livre:"$corPadrao" $MEMORIALIVRE"
echo -e ""$amarelo"Quantidade de processos:"$corPadrao" $PROCESSOS"
echo -e ""$amarelo"UPTIME e LOAD:"$corPadrao" $UPTIME"

echo -e ""$vermelho"\n====================================================="
echo -e "           Informações sobre o APACHE                "
echo -e "====================================================="$corPadrao""

echo -e ""$amarelo"$APACHEINFO"$corPadrao""
#echo -e ""$amarelo"Uptime APACHE:"$corPadrao"$UPTIMEAPACHE"
#echo -e ""$amarelo"Versão APACHE:"$corPadrao"$APACHEVERSION"
echo -e ""$amarelo"Requisições sendo processadas:"$corPadrao" $APACHEPROC"
echo -e ""$amarelo"Processos ociosos:"$corPadrao" $PROCOCIOSO"
