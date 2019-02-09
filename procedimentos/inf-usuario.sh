#!/bin/bash

#################################################################################
# DESCRIÇÂO                                                                     #
# Recebe o nome do usuário e pesquisa informações sobre este.                   #
#                                                                               #
# • Nome da Máquina								#      
# • UID do usuário								#
# • Nome Completo / Descrição do Usuário					#
# • Total em Uso no /home do usuário						#
# • Informações do último login do usuário					#
# • [Opcional] Validar se o usuário existe ou não.				#
#################################################################################

USUARIO=""
HOMEUSER=""

read -p "Informe o nome do usuário: " USUARIO
HOMEUSER="$(grep "$USUARIO" /etc/passwd | awk -F: {'print $6'})"
HOMEDISK="$(grep "$USUARIO" /etc/passwd | awk -F: {'print $6'} | du -sh)"
echo -e "\n============================================================"
echo -e "\nRelatório do usuário: $USUARIO"
echo -e "\nUID: $(grep "$USUARIO" /etc/passwd | awk -F: {'print $3'})"
echo -e "Nome ou Descrição: $(grep "$USUARIO" /etc/passwd | awk -F: {'print $5'} | sed 's/,//g')"
echo -e "\nTotal Usado no $HOMEUSER: $HOMEDISK" 
echo -e "\nUltimo Login:"
echo -e "$(lastlog -u "$USUARIO")"
echo -e "\n============================================================"
