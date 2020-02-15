#!/bin/bash


#################################################################################################################################
#                                                                                                                               #
# Nome: migra-email.sh		                                                                                                    #
#                                                                                                                               #
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)                                                                           #
# Data: 03/03/19                                                                                                                #
#                                                                                                                               #
# Descrição: Faz a leitura do csv dos dados das contas e sincroniza elas através do imapsync			                        #
#								                                                                                                #
# Planilha deve conta na 1ª servidor de origem, 2ª Email, 3ª senha origem, 4 Servidor de destino, 5ª senha destino		        #
# Homologado:				                                                                                                    #
# Modelo: https://docs.google.com/spreadsheets/d/1bQdPS2Q-LOy0G-zvpHgABQ8rClYhUk40ZGOursIL5vg/edit?usp=sharing                  #
#                                                                                                                               #
# USO: ./migra-email.sh                                                                                                         #
# Arquivo csv deve ficar onde irá rodar o script                                                                                #
#################################################################################################################################

DATAHORA=`date "+%d-%m-%Y %H:%M:%S"`


#read -p "Informe o host de origem: " SRVORIGEM
#read -p "Informe o host de destino:" SRVDESTINO

#Definindo cores
corPadrao="\033[0m"
vermelho="\033[0;31m"

echo -e ""$vermelho"=================================================================================="
echo -e "                      Atenção - Script de sincronia iniciando                      "                  
echo -e "=================================================================================="$corPadrao""

#read -p "Informe seu e-mail de contato: " CONTATO


for LINHA in $(cat contas.csv)  
do	
	SRVORIGEM=`echo $LINHA | awk -F, '{print $1}' | tr -d "[:space:]"`
	SRVDESTINO=`echo $LINHA | awk -F, '{print $4}' | tr -d "[:space:]"`
	CONTA=`echo $LINHA | awk -F, '{print $2}' | tr -d "[:space:]"`
	SENHA1=`echo $LINHA | awk -F, '{print $3}'| tr -d "[:space:]"`
	SENHA2=`echo $LINHA | awk -F, '{print $5}' | tr -d "[:space:]"`


	#echo $SRVORIGEM
	#echo ${#SRVORIGEM}
	#echo $SRVDESTINO
	#echo ${#SRVDESTINO}
	#echo "$CONTA"
	#echo ${#CONTA}
	#echo "$SENHA1"
	#echo ${#SENHA1}
	#echo "$SENHA2"
	#echo ${#SENHA2}


	echo -e ""$vermelho"\nIniciando a sincronia da conta $CONTA as $DATAHORA"$corPadrao""

	#imapsync --host1 "$SRVORIGEM" --user1 "$CONTA"  --password1 $SENHA1 --host2 "$SRVDESTINO" --user2 "$CONTA" --password2 $SENHA2
	imapsync --host1 "$SRVORIGEM" --port1 993 --user1 "$CONTA" LOGIN --ssl1 --password1 $SENHA1 --host2 "$SRVDESTINO" --port2 993 --user2 "$CONTA" LOGIN --ssl2 --password2 $SENHA2

	echo -e ""$vermelho"\nFinalizando a sincronia da conta $CONTA as $DATAHORA"$corPadrao""
done

echo -e "\n"$vermelho"Sincronia de e-mails finalizada as $DATAHORA"$corPadrao""
echo -e "\n"$vermelho"Logs do processo estão armazenado na pasta LOG_imapsync"$corPadrao""
