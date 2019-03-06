#!/bin/bash

DOMINIO=""
USUARIO=""
IDTKT=""
DESTINO=""

read -p "Informe o domínio: " DOMINIO
echo $DOMINIO > /tmp/dominio.tmp

#Validando existencia do domínio
if [ ! $(grep -w "$DOMINIO" /etc/trueuserdomains | awk {'print $1'}) ]
then
        echo "Domínio não encontrado!"
        exit 1
fi

read -p "Informe o destino: " DESTINO
echo $DESTINO > /tmp/destino.tmp

#Checando se o destino está online
if ! $(ping -c2 "$DESTINO" > /dev/null) 
then
	echo "Servidor Offline ou não está dentro da hostgator."
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
        	#IDTKT=`source <(curl -ks https://git.hostgator.com.br/advanced-support/migration/raw/master/open.sh) --domain $DOMINIO --destination $DESTINO`
		IDTKT=26666
		echo $IDTKT > /tmp/idtkt.tmp
		;;
	2)
	        read -p "\nInforme o TICKET ..." IDTKT
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
read -p "Opção: " OPCAO
echo ""

case "$TIPOCONTA" in
	1)
		TIPO="USER"
		echo $TIPOCONTA > tipo.tmp
		;;
	2)
		TIPO="RESELLER"
		echo $TIPOCONTA > tipo.tmp
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


echo "Domínio = $DOMINIO"
echo "Usuário = $USUARIO"
echo "Tipo = $TIPOCONTA"
echo "Destino = $DESTINO"
echo "ID do Ticket = $IDTKT"


#	MIGRA=`source <(curl -ks https://git.hostgator.com.br/monitoramento/migracao/raw/master/migracao.sh) --idtkt "$IDTKT" --destination "$DESTINO" --port "22" --type "$TIPO" --accounts "$USUARIO" --email "thiago.dantas@endurance.com" --skip-dns`

#	echo -e "\nIniciando a migração!"
#	$MIGRA
#
#fi

echo -e "\nFinalizado as $(date)"
