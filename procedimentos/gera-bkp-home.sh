#!/bin/bash

#################################################################
#								#
# Nome: gera-bkp-home.sh					#
#								#
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)		#
# Data: 13/02/19						#
#								#
# Descrição: Faz um backup da home do usuário informado		#
#								#
# USO: ./gera-bkp-home.sh					#
#								#
#################################################################

USUARIO=""

read -p "Informe o usuário: " USUARIO

COLETAHOME="$(grep "$USUARIO" /etc/passwd | awk -F: {'print $6'})"
ARMZBKP="$COLETAHOME/Backup/"
DIAS7="$(find $ARMZBKP -ctime -7 -name backup_home\*tar.gz)"
ARQUIVO="backup_home_$(date +%Y%m%d%H%M).tar.gz"

#echo $USUARIO
#echo $COLETAHOME
#echo $ARMZBKP

#Criando o diretório de backup, caso não exista
if [ !-d $ARMBKP ]
then
		echo "Criando diretório $ARMZBKP..."
		mkdir -p $ARMZBKP
fi

#Faz o teste
if [ "$DIAS7" ]
then
	echo "Já foi gerado um backup do diretório $COLETAHOME em menos de 7 dias."
	echo -n "Deseja continuar? (N/s): "
	read -n1 CONT
	
	echo ""

	if [ "$CONT" = N -o "$CONT" = n -o "$CONT" = "" ]
		then
			echo "Backup cancelado!"
			exit 1
		elif [ $CONT = S -o $CONT = s ]
		then
			echo "Será criando mais um backup."
		else
			echo "Opção Inválida."
			exit 2
	fi
fi

echo "Criando Backup ..."

tar zcvpf $ARMZBKP/$ARQUIVO --absolute-names --exlude="$ARMZBKP" "$COLETAHOME"/*

echo
echo "O backup de nome \""$ARQUIVO"\" foi criado em $ARMZBKP"
echo 
echo "Backup Concluído!"
