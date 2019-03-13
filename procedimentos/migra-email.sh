#!/bin/bash


#################################################################################################################################
#                                                                                                                               #
# Nome: migra-email.sh			                                                                                                #
#                                                                                                                               #
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)                                                                           #
# Data: 03/03/19                                                                                                                #
#                                                                                                                               #
# Descrição: Faz a leitura do csv dos dados das contas e sincroniza elas através do imapsync					                #
#								                                                                                                #
# Planilha deve conta na 1ª colune e-mail, 2ª senha e 3ª sena de destino														#
# Homologado:						                                                                                            #
#                                                                                                                               #
# BUG -> Inicialmente efetuando a leitura do host pela planilha apresenta erros, por esse motivo estou lendo pelo read ate o fix#  
#                                                                                                                               #
# USO: ./migra-email.sh                                                                                                         #
#                                                                                                                               #
#################################################################################################################################

DATAHORA=`date "+%d-%m-%Y %H:%M:%S"`
LOG="/var/log/migra-email.log"

#read -p "Informe o host de origem: " SRVORIGEM
#read -p "Informe o host de destino:" SRVDESTINO

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

	echo -e "\nIniciando a sincronia da conta $CONTA as $DATAHORA"

	imapsync --host1 "$SRVORIGEM" --user1 "$CONTA"  --password1 $SENHA1 --host2 "$SRVDESTINO" --user2 "$CONTA" --password2 $SENHA2

	echo -e "\nFinalizando a sincronia da conta $CONTA as $DATAHORA"
done

echo -e "\nSincronia de e-mail finalizada as $DATAHORA"
