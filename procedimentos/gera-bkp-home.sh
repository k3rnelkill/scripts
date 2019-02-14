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
DIRDEST="$COLETAHOME/Backup/"
DIAS7="$(find $DIRDEST -ctime -7 -name backup_home\*tar.gz)"
ARQUIVO="backup_home_$(date +%Y%m%d%H%M).tar.gz"

#Criando o diretório de backup, caso não exista
if [ ! -d $DIRDEST ]
then
		echo "Criando diretório $DIRDEST..."
		mkdir -p $DIRDEST
fi

#DIAS7="$(find $DIRDEST -ctime -7 -name backup_home\*tar.gz)"

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

tar zcvpf $DIRDEST/$ARQUIVO --absolute-names --exclude="$DIRDEST" "$COLETAHOME"/*
echo
echo "O backup de nome \""$ARQUIVO"\" foi criado em $DIRDEST"
echo 
echo "Backup Concluído!"
