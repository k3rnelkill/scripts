#!/bin/bash

#################################################################################
# Nome: relatorio.sh								#
# 										#
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)				#
# Data: 10/02/2019								#
# DESCRIÇÂO									#
# Gere um relatório de algumas informações da máquina atual.		        #
#  									        #
#• Nome da Máquina							        #
#• Data e Hora Atual							        #
#• Desde quando a máquina está ativa						#
#• Versão do Kernel								#
#• Quantidade de CPUs/Cores							#
#• Modelo da CPU								#
#• Total de Memória RAM Disponível						#
#• Partições									#
#										# 
#  USO: ./relatorio.sh								#
#################################################################################

clear

HOSTNAME="`hostname`"
DATA="`date`"
KERNEL="`uname -r`"
CPU="/proc/cpuinfo"

echo -e "\n================================================================================"
echo -e "\nRelatório da Máquina: $HOSTNAME"
echo -e "\nDATA/HORA: $DATA"
echo -e "\n================================================================================"


echo -e "\nAtiva a: $(uptime | awk {'print ($3)'} | sed 's/,//') dia."
echo -e "Desde:   $(uptime -s)"
echo ""
echo -e "\nVersão do Kernel: $KERNEL"
echo ""
echo -e "\nCPUs:"
echo -e "Quantidade de CPUs/Core: $(cat $CPU | grep processor | wc -l)"
echo -e "Modelo da CPU: $( cat $CPU | grep "model name" | tail -n1)"
echo -e "\nMemória Total: $(free | grep "Mem:" | awk {'print $2'}) MB"
echo -e "\nPartições:"
echo -e "$(df -kh | egrep -v '(tmpfs|udev|none)')"
