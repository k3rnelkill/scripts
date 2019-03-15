#!/bin/bash

#################################################################################################################################################
#																		#
# Nome: install_imapsync.sh															#
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)												#
# Data: 15/03/2019																#
#																		#
# Descrição: Faz a instalação do imapsync em diferentes sistemas operacionais									#
# links, script essencial para utilizar o migra-email.sh											#
#																		#
# Homolagado: Em Desenvolvimento														#
#																		#
#																		#
# Uso: ./install_imapsync.sh ou bash <(curl -ks https://raw.githubusercontent.com/marquesms/scripts/master/procedimentos/install_imapsync.sh)	#
#																		#
#################################################################################################################################################

#DEFININDO CORES
corPadrao="\033[0m"
vermelho="\033[1;31m"
branco="\033[1;37m"
amarelo="\033[1;33m"
azulClaro="\033[1;34m"

echo -e ""$azulClaro"==============================================================================="
echo -e "Atenção - Script irá instalar todas as dependencias necessárias para o IMAPSYNC"
echo -e "==============================================================================="$corPadrao""

echo ""
echo -e "Informe o Sistema Operacional"
echo ""
echo -e ""$amarelo"1 - Ubuntu"$corPadrao""
echo -e ""$amarelo"2 - Debian"$corPadrao""
echo -e ""$amarelo"3 - CentOS 6"$corPadrao""
echo -e ""$amarelo"4 - CentOS 7"$corPadrao""
echo -e ""$vermelho"Q - Sair"$corPadrao""
echo ""
read -p "Opção: " OPCAO
echo ""

case "$OPCAO" in
	1)
		echo -e "\nIniciando instalação no $OPCAO ..."
		;;
	2)
		echo -e "\nIniciando instalação no $OPCAO ..."
		;;
	3)
		echo -e "\nIniciando instalação no $OPCAO ..."
		;;
	4)
		echo -e "\nIniciando instalação no $OPCAO ..."
		;;
	[Qq])
		echo -e "Saindo ..."
		exit
		;;
	*)
		echo -e ""$vermelho"Opção Invalida mané!"$corPadrao""
		exit 2
		;;
esac
