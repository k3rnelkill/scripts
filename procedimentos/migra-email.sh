#!/bin/bash


#################################################################
#                                                               #
# Nome: migra-email.sh			                        #
#                                                               #
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)           #
# Data: 03/03/19                                                #
#                                                               #
# Descrição: Faz a leitura do csv dos dados das contas e sincron#
# iza elas através do imapsync					                #
#								                                #
# Homologado:						                            #
#                                                               #
# USO: ./migra-email.sh                                         #
#                                                               #cat
#################################################################

DATAHORA=`date "+%d-%m-%Y %H:%M:%S"`
LOG="/var/log/migra-email.log"
#read -p "Informe o servidor de ORIGEM: " SRVORIGEM
#read -p "Informe o servidor de DESTINO: " SRVDESTINO
SRVORIGEM=ews2.datatop.com.br
SRVDESTINO=ewr5.datatop.com.br


for LINHA in $(cat /root/contas.txt)  
do	
	CONTA=`echo $LINHA | awk -F, '{print $1}'`
	CONTA2=`echo $LINHA | awk -F, '{print $1}'`
	#SENHA1=`echo $LINHA | awk -F, '{print $2}'`
	#SENHA2=`echo $LINHA | awk -F, '{print $3}'`

	#echo -e "\n Iniciando sincronia da conta $CONTA -> $DATAHORA" >> $LOG

	#echo "$CONTA""-"$SENHA1"-""$CONTA""-"$SENHA2

 	imapsync --host1 $SRVORIGEM --user1 teste2@commitlinux.com.br  --password1 '0YIKynhqWWyY' --host2 $SRVDESTINO --user2 teste2@commitlinux.com.br --password2 '0YIKynhqWWyY'
	#echo $? >> $LOG

 	#echo -e "\nFinalizado sincronia da conta $CONTA -> $DATAHORA" >> $LOG

done
