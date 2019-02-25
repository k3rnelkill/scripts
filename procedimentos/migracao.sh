#!/bin/bash

DOMINIO=""
USUARIO=""
IDTKT=""
DESTINO=""

read -p "Informe o domínio: " DOMINIO
read -p "Informe o destino: " DESTINO

#export $DOMINIO
#export $DESTINO

#Verificando se o domínio existe
if [ ! $(grep -w "$DOMINIO" /etc/trueuserdomains | awk {'print $1'}) ]
then
	echo "Domínio não encontrado!"

else

	echo -e "\nCriando TICKET ..."
	IDTKT=`source <(curl -ks https://git.hostgator.com.br/advanced-support/migration/raw/master/open.sh) --domain $DOMINIO --destination $DESTINO`
	

	#Coletando usuário
	echo -e "\nColetando usuário."
	USUARIO="$(grep "$DOMINIO" /etc/trueuserdomains | sed 's/ //g' | awk -F: {'print $2'})"
	export $USUARIO

	#Verificando tipo de conta
	echo ""
	echo "Escolhe a Opção referente ao tipo de conta."
	echo "1 = Usuário"
	echo "2 = Revenda"
	echo "Q = SAIR"
	echo ""
	read -p "Opção: " OPCAO
	echo ""

	case $OPCAO in
		1)
			TIPO="USER"
			;;
		2)
			TIPO="RESELLER"
			;;

		[Qq])
			echo "Saindo ..."
			exit
			;;
		*)
			echo "Opção inválida!"
			exit 1
			;;
	esac

	export $TIPO

	echo "Domínio = $DOMINIO"
	echo "Usuário = $USUARIO"
	echo "Tipo = $TIPO"
	echo "Destino = $DESTINO"
	echo "ID do Ticket = $IDTKT"


	MIGRA=`source <(curl -ks https://git.hostgator.com.br/monitoramento/migracao/raw/master/migracao.sh) --idtkt "$IDTKT" --destination "$DESTINO" --port "22" --type "$TIPO" --accounts "$USUARIO" --email "thiago.dantas@endurance.com" --skip-dns`

	echo -e "\nIniciando a migração!"
	$MIGRA

fi

echo -e "\nFinalizado as $(date)"
