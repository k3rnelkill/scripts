#!/bin/bash

#################################################################################
# DESCRIÇÂO                                                                     #
# Recebe o nome do usuário e pesquisa informações sobre este.                   #
#										#
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)                           #
# Data: 10/02/2019								#
#                                                                               #
# • Nome da Máquina								#      
# • UID do usuário								#
# • Nome Completo / Descrição do Usuário					#
# • Total em Uso no /home do usuário						#
# • Informações do último login do usuário					#
# • Valida se o usuário existe ou não.						#
# • USO: ./inf-usuario.sh							#
#################################################################################

clear
echo ""

USUARIO=""
HOMEUSER=""

read -p "Informe o nome do usuário: " USUARIO 

#Efetuando a validação do usuário
if id -u "$USUARIO" > /dev/null 2>&1; then 
	#echo -e "\nUtilizador $USUARIO existe";

	HOMEUSER="$(grep "$USUARIO" /etc/passwd | awk -F: {'print $6'})"
	HOMEDISK="$(du -sh "$HOMEUSER" | cut -f1)"
	echo -e "\n============================================================"
	echo -e "\nRelatório do usuário: $USUARIO"
	echo -e "\nUID: $(grep "$USUARIO" /etc/passwd | awk -F: {'print $3'})"
	echo -e "Nome ou Descrição: $(grep "$USUARIO" /etc/passwd | awk -F: {'print $5'} | sed 's/,//g')"
	echo -e "\nTotal utilizando no $HOMEUSER: $HOMEDISK"
	echo -e "\nUltimo Login:"
	echo -e "$(lastlog -u "$USUARIO")"
	echo -e "\n============================================================"
else 
	echo "O utilizado $USUARIO não existe" 
fi
