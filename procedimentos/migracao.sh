#!/bin/bash

#########################################################################################################################
#                                                               														#
# Nome: migracao.sh                                    																	#
#                                                               														#
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)           														#
# Data: 24/02/19                                                														#
#                                                               														#
# Descrição: script para criação do ticket e migração de revenda e contas simples										#
#																														#
# Script é um aglomerado de código de outros profissionais e amigos da hostgator, somente fiz a parte mais simples de   # 
# concatenar tudo em um e colocar algumas modificações para facilitar minha vida.										#
#																														#
# USO: bash <(curl -ks https://raw.githubusercontent.com/marquesms/scripts/master/procedimentos/check-information.sh)   #
#                                                               														#
#########################################################################################################################

#DEFININDO CORES
corPadrao="\033[0m"
vermelho="\033[1;31m"
branco="\033[1;37m"
amarelo="\033[1;33m"
azulClaro="\033[1;34m"

#VARIAVEIS
DOMINIO=""
USUARIO=""
IDTKT=""
DESTINO=""

echo -e ""$azulClaro"=================================================================================="
echo -e "                      Atenção - Script de Migração iniciando                      "                  
echo -e "=================================================================================="$corPadrao""


#Leitura da origem, será utilizado a criação do ticket e coleta do usuário.
read -p "Informe o domínio: " DOMINIO
echo $DOMINIO > /tmp/dominio.tmp

#Validando existencia do domínio
if [ ! $(grep -w "$DOMINIO" /etc/trueuserdomains | awk {'print $1'}) ]
then
        echo -e ""$vermelho"Domínio não encontrado!"$corPadrao""
        exit 1
fi

#Leitura do destino, o obvio
read -p "Informe o destino: " DESTINO
echo $DESTINO > /tmp/destino.tmp

#Checando se o destino está online
if ! $(ping -c2 "$DESTINO" > /dev/null 2>&1) 
then
	echo -e ""$vermelho"Servidor Offline ou não está dentro da hostgator."$corPadrao""
	exit 1
fi

#Coletando usuário
echo -e "\nColetando usuário."
USUARIO="$(grep "$DOMINIO" /etc/trueuserdomains | sed 's/ //g' | awk -F: {'print $2'})"
echo $USUARIO > /tmp/usuario.tmp


#Verifica se precisa criar um ticket ou não.
echo ""
echo "Deseja cria um ticket?"
echo ""
echo "1 - SIM"
echo "2 - NÂO"
echo "Q - SAIR"
echo ""
read -p "Opção: " OPCAOTKT
echo ""

case "$OPCAOTKT" in
	1)
		echo -e "\nCriando TICKET ..."
        	IDTKT=`source <(curl -ks https://git.hostgator.com.br/advanced-support/migration/raw/master/open.sh) --domain $DOMINIO --destination $DESTINO`
		echo $IDTKT > /tmp/idtkt.tmp
		;;
	2)
	        read -p "Informe o TICKET: " IDTKT
		echo $IDTKT > /tmp/idtkt.tmp
		;;
	
	[Qq])
		echo "Saindo ..."
		exit
		;;
	*)	
		echo "Opção Inválida!"
		exit 2
		;;
esac	


#VERIFICANDO TIPO DE CONTA
echo ""
echo "Escolhe a Opção referente ao tipo de conta."
echo "1 - Usuário"
echo "2 - Revenda"
echo "Q - SAIR"
echo ""
read -p "Opção: " TIPOCONTA
echo ""

case "$TIPOCONTA" in
	1)
		TIPOCONTA="USER"
		echo $TIPOCONTA > /tmp/tipo.tmp
		;;
	2)
		TIPOCONTA="RESELLER"
		echo $TIPOCONTA > /tmp/tipo.tmp
		;;
	[Qq])
		echo "Saindo ..."
		exit
		;;
	*)
		echo "Opção inválida!"
		exit 2
		;;
esac

#Fazendo a impressão da variavel antes da execuão, assim usuário pode confirmar os parametros passados
echo -e ""$vermelho"Domínio = "$corPadrao"$DOMINIO"
echo -e ""$vermelho"Usuário = "$corPadrao"$USUARIO"
echo -e ""$vermelho"Tipo = "$corPadrao"$TIPOCONTA"
echo -e ""$vermelho"Destino = "$corPadrao"$DESTINO"
echo -e ""$vermelho"ID do Ticket = "$corPadrao"$IDTKT"


	MIGRA=`source <(curl -ks https://git.hostgator.com.br/monitoramento/migracao/raw/master/migracao.sh) --idtkt "$IDTKT" --destination "$DESTINO" --port "22" --type "$TIPO" --accounts "$USUARIOCONTA" --email "thiago.dantas@endurance.com" --skip-dns`

	echo -e "\nIniciando a migração!"
	$MIGRA

echo -e "\nFinalizado as $(date)"
