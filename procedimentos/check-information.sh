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

VERSAO=$(grep -Eo '[0-9]' /etc/centos-release | head -n1)
PROCESSOS=$((`ps aux | wc -l` - 1))
UPTIME=`uptime`
MEMORIATOTAL=`free -h | grep "Mem" | awk {'print $2'}`
MEMORIALIVRE=`free -h | grep "Mem" | awk {'print $4'}`
MYSQLUPTIME=`mysql -e "\s" | grep "Uptime:"`
MYSQLSERVER=`mysql -e "\s" | grep "Server:"`
MYSQLV=`mysql -e "\s" | grep "Server version:"`
MYSQLUPTIME=`mysql -e "\s" | grep "Uptime:"` 
QTDCPU=`cat /proc/cpuinfo | grep "processor" | wc -l`
MODELCPU=`cat /proc/cpuinfo | grep "model name" | tail -n1 | awk -F: {'print $2'}`
DISCO=`df -kh | egrep -v '(tmpfs|udev|none|var|usr|home|boot)'`


#DEFININDO CORES
corPadrao="\033[0m"
vermelho="\033[1;31m"
branco="\033[1;37m"
amarelo="\033[1;33m"

#VERIFICA VERSAO SO
if [ $VERSAO -eq 6 ]
then
        echo "CentOS 6"
	APACHEINFO=`service httpd fullstatus | head -n3`
	MPM=`service httpd fullstatus | grep "Server MPM:"`
	UPTIMEAPACHE=`service httpd fullstatus | grep "Server uptime"`
	APACHEPROC=`service httpd fullstatus | grep "currently"`
else
        echo "CentOS 7"
	APACHEINFO=`apachectl fullstatus | head -n3`
	MPM=`apachectl fullstatus | grep "Server MPM:"`
	UPTIMEAPACHE=`apachectl fullstatus | grep "Server uptime"`
	APACHEPROC=`apachectl fullstatus | grep "currently"`
fi

clear
echo -e "$vermelho=================================================================================="
echo -e "                           Informações de Hardware"                  
echo -e "=================================================================================="$corPadrao""

echo -e ""$amarelo"Qtd de memória total:"$corPadrao" $MEMORIATOTAL"
echo -e ""$amarelo"Qtd de CPU:"$corPadrao" $QTDCPU"
echo -e ""$amarelo"Modelo CPU:"$corPadrao"$MODELCPU"
echo -e "\n"$amarelo"Partições:"
echo -e ""$corPadrao"$DISCO"

echo -e "\n$vermelho================================================================================"
echo -e "                             Informações de uso"
echo -e "================================================================================"$corPadrao""

echo -e ""$amarelo"Qtd de memória livre:"$corPadrao" $MEMORIALIVRE"
echo -e ""$amarelo"Quantidade de processos:"$corPadrao" $PROCESSOS"
echo -e ""$amarelo"UPTIME e LOAD:"$corPadrao" $UPTIME"

echo -e ""$vermelho"\n================================================================================"
echo -e "                           Informações sobre o APACHE"
echo -e "================================================================================"$corPadrao""

echo -e ""$amarelo"$APACHEINFO"$corPadrao""
echo -e ""$amarelo"$MPM"$corPadrao""
echo -e ""$amarelo"$UPTIMEAPACHE"$corPadrao""
echo -e ""$amarelo"Requisições sendo processadas:"$corPadrao"$APACHEPROC"

echo -e ""$vermelho"\n================================================================================"
echo -e "                           Informações sobre o MYSQL"
echo -e "================================================================================"$corPadrao""

echo -e ""$amarelo"$MYSQLSERVER"$corPadrao""
echo -e ""$amarelo"$MYSQLV"$corPadrao""
echo -e ""$amarelo"$MYSQLUPTIME"$corPadrao""
