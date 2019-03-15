#!/bin/bash

#####################################################################################################################################
#                                                                                                                                   #
# Nome: install_imapsync.sh		                                                                                                    #
#                                                                                                                                   #
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)                                                                               #
# Data: 15/03/2019                                                                                                                  #
#                                                                                                                                   #
# Descrição: Faz a instalação do imapsync em diferentes sistemas operacionais links, script essencial para utilizar o migra-email.sh#
#								                                                                                                    #
# Homologado:				                                                                                                        #
#                 																													#
#                                                                                                                                   #
# USO: ./install_imapsync.sh ou bash <(curl -ks )                                                                                   #
#                                                                                                                                   #
#####################################################################################################################################

#DEFININDO CORES
corPadrao="\033[0m"
vermelho="\033[1;31m"
branco="\033[1;37m"
amarelo="\033[1;33m"
azulClaro="\033[1;34m"

echo -e ""$azulClaro"==============================================================================="
echo -e "Atenção - Script irá instalar todas as dependencias necessárias para o IMAPSYNC"                  
echo -e "==============================================================================="$corPadrao""