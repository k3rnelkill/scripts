#!/bin/bash

USUARIO=`pwd | awk -F/ {'print $3'}`
HOMEUSER=`grep "$USUARIO" /etc/passwd | awk -F: {'print $6'}`
DIR="$HOMEUSER"/.spamassassin""

echo $USUARIO
echo $HOMEUSER

if [ -f $HOMEUSER"/.spamassassinenable" ]
then
	echo -e "Executando o IF"
	echo -e "\nJá existe um Spam Filter ativo"
	echo ""
	echo -e "\nDeseja sobrescrever a configuração?"
	echo ""
	echo "1 - SIM"
	echo "2 - NÂO"
	echo ""
	read -p "Opcao: " OPCAO
	echo ""

	case "$OPCAO" in
		1)	
			
			;;
		2) 
			echo "Saindo ..."
			exit
			;;	
		*)
			echo "Opção selecionada invalida"
			exit 2
			;;
	esac	

else
	echo -e "Executando o ELSE\n"
	if [ ! -d $DIR ]
	then
           	echo "Criando o diretório $DIR ..."
            	mkdir -p $DIR
           	touch $DIR"/user_prefs"
		touch $HOMEUSER"/.spamassassinenable"
           	echo "required_score 5" > $DIR"/user_prefs"
	fi

	if [ ! -f $DIR"/user_prefs" ]
	then
		echo "Criando arquivo user_prefs"
		touch $DIR"/user_prefs"
		echo "required_score 5" > $DIR"/user_prefs"
	fi
fi
