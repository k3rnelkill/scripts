#!/bin/bash

#################################################################################
#DESCRIÇÂO									#
#Gere um relatório de algumas informações da máquina atual.		        #
#  									        #
#• Nome da Máquina							        #
#• Data e Hora Atual							        #
#• Desde quando a máquina está ativa						#
#• Versão do Kernel								#
#• Quantidade de CPUs/Cores							#
#• Modelo da CPU								#
#• Total de Memória RAM Disponível						#
#• Partições									#
#  Autor: Thiago Marques 							#
#  E-mail: thiagomarquesdums@gmail.com						#
#  Formas de uso.								#
#  De preferencia, deixe o arquivo em sua pasta de scripts lidos pelo path	#
#################################################################################


HOSTNAME="`hostname`"
DATA="`date`"
KERNEL="`uname -r`"
CPU="/proc/cpuinfo"

clear

echo -e "\n================================================================================"
echo -e "\nRelatório da Máquina: $HOSTNAME"
echo -e "\nDATA/HORA: $DATA"
echo -e "\n================================================================================"


echo -e "\nMáquina Ativa desde: $(uptime | awk {'print ($1,$2,$3)'} | sed 's/,//')"
echo ""
echo -e "\nVersão do Kernel: $KERNEL"
echo ""
echo -e "\nCPUs:"
echo -e "Quantidade de CPUs/Core: $(cat $CPU | grep processor | wc -l)"
echo -e "Modelo da CPU: $( cat $CPU | grep "model name" | tail -n1)"
echo -e "\nMemória Total: $(free | grep "Mem:" | awk {'print $2'}) MB"
echo -e "\nPartições:"
echo -e "$(df -kh)"
