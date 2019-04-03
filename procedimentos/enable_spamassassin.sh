#!/bin/bash

USUARIO=`pwd | awk -F/ {'print $3'}`
HOMEUSER=`grep "$USUARIO" /etc/passwd | awk -F: {'print $6'}`
DIRSPAM="$HOMEUSER"/.spamassassin""

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
			if [ ! -d $DIRSPAM ]
        		then
                		echo "Criando o diretório $DIRSPAM ..."
                		mkdir -p $DIRSPAM
                		echo "required_score 5" > $DIRSPAM"/user_prefs"
			else
				echo "required_score 5" > $DIRSPAM"/user_prefs"	
			fi
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
	if [ ! -d $DIRSPAM ]
	then
           	echo "Criando o diretório $DIRSPAM ..."
            	mkdir -p $DIRSPAM
		touch $HOMEUSER"/.spamassassinenable"
           	echo "required_score 5" > $DIRSPAM"/user_prefs"
	fi

	if [ ! -f $DIRSPAM"/user_prefs" ]
	then
		echo "Criando arquivo user_prefs"
		echo "required_score 5" > $DIRSPAM"/user_prefs"
	fi
fi
