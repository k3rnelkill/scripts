#!/bin/bash

#########################################################################################################################################
#                                                                                                                                       #
# Nome: enable_spamassassinv2.sh                                                                                                        #
#                                                                                                                                       #
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)                                                                                   #
# Data: 02/04/19                                                                                                                        #
#                                                                                                                                       #
# Descrição: Faz ativação do apachespamassassin e criação do filtro com algumas regras funcionas                                        #
#                                                                                                                                       #
# USO: ./enable_spamassassinv2.sh ou                                                                                                    #
# bash <( -ks https://raw.githubusercontent.com/marquesms/scripts/master/procedimentos/enable_spamassassinv2.sh                         #
#                                                                                                                                       #
#########################################################################################################################################

USUARIO=`pwd | awk -F/ {'print $3'}`
HOMEUSER=`grep "$USUARIO" /etc/passwd | awk -F: {'print $6'}`
DIR="$HOMEUSER"/.spamassassin""
DATA=`date +%Y%m%d"_"%H%M`
FILTRO=`wget https://raw.githubusercontent.com/marquesms/scripts/master/procedimentos/filter.txt -O "$HOMEUSER/filter.txt"`
FILTRO2=`wget https://raw.githubusercontent.com/marquesms/scripts/master/procedimentos/filter2.txt -O "$HOMEUSER/filter.txt"`
CACHEFILTRO=`wget https://raw.githubusercontent.com/marquesms/scripts/master/procedimentos/filter.cache.txt -O "$HOMEUSER/filter.cache.txt"`

echo $USUARIO
echo $HOMEUSER



if [ -f $HOMEUSER"/.spamassassinenable" ]
then
	echo -e "Executando o IF"
	echo -e "\nJá existe um Spam Filter ativo"
	echo ""
	echo -e "\nDeseja sobrescrever a configuração?"
	echo ""
	echo "1 - SIM Sobrescrever"
	echo "2 - Aplicar somente o Filtros de SPAM"
	echo ""
	echo -e "3 - SAIR"
	echo ""
	read -p "Opcao: " OPCAO
	echo ""

	case "$OPCAO" in
		1)          
			$FIlTRO
			$CACHEFILTRO
			echo "Refazendo ativação padrão"
			sleep 1
			uapi --user="$USUARIO" Email disable_spam_assassin
			echo "Score Spam 5.0"
			sleep 1
			uapi --user="$USUARIO" Email enable_spam_assassin 
			uapi --user="$USUARIO" SpamAssassin update_user_preference preference=score value-0="ACT_NOW_CAPS 5.0"
			echo -e "Habilitando auto Delete"
			sleep 1
			cpapi1 --user="$USUARIO" Email enable_spam_autodelete
			echo -e "Efetuando backup do vFilter"
			for DOMINIOS in $(/bin/cat /etc/userdomains | grep "$USUARIO" | awk -F: {'print $1'}); do /bin/cp -pv /etc/vfilters/"$DOMINIOS" "$HOMEUSER"/"$DATA"_vfilter_"$DOMINIOS"; done
			sleep 1
			echo -e "Habilitando o Spam Filter"
			for DOMINIOS in $(/bin/cat /etc/userdomains | grep "$USUARIO" | awk -F: {'print $1'}); do /bin/cat filter.txt > /etc/vfilters/"$DOMINIOS"; done
			/bin/cat "$HOMEUSER"/filter.cache.txt > "$HOMEUSER"/.cpanel/filter.cache
			echo "Limpando os dovecot"
			sleep 1
			/scripts/remove_dovecot_index_files --user="$USUARIO" --verbose
			;;  
		2)  
			$FIlTRO2
			$CACHEFILTRO
			echo "Aplicando Filtros"
			sleep 1		
			echo -e "Efetuando backup do vFilter"
			for DOMINIOS in $(/bin/cat /etc/userdomains | grep "$USUARIO" | awk -F: {'print $1'}); do /bin/cp -pv /etc/vfilters/"$DOMINIOS" "$HOMEUSER"/"$DATA"_vfilter_"$DOMINIOS"; done
			sleep 1
			echo -e "Habilitando o Spam Filter"
			for DOMINIOS in $(/bin/cat /etc/userdomains | grep "$USUARIO" | awk -F: {'print $1'}); do /bin/cat filter.txt > /etc/vfilters/"$DOMINIOS"; done
			/bin/cat "$HOMEUSER"/filter.cache.txt > "$HOMEUSER"/.cpanel/filter.cache
			sleep 1
			/scripts/remove_dovecot_index_files --user="$USUARIO" --verbose
			;; 
		3)
			echo "Saindo ..."
			exit
			;;
		*)  
			echo "Opção selecionada invalida"
			exit 2
			;;  
	esac    

else
	$FIlTRO
	$CACHEFILTRO
	echo "Entrando no else de ativação"
	echo "Ativando SPAMASSASSIN do usuário "$USUARIO" ..."
	sleep 1
	uapi --user="$USUARIO" Email enable_spam_assassin
	echo "Score Spam 5.0"
	sleep 1
	uapi --user="$USUARIO" SpamAssassin update_user_preference preference=score value-0="ACT_NOW_CAPS 5.0"
	echo -e "Habilitando auto Delete"
	sleep 1
	cpapi1 --user="$USUARIO" Email enable_spam_autodelete
	echo -e "Efetuando backup do vFilter"
	for DOMINIOS in $(/bin/cat /etc/userdomains | grep "$USUARIO" | awk -F: {'print $1'}); do /bin/cp -pv /etc/vfilters/"$DOMINIOS" "$HOMEUSER"/"$DATA"_vfilter_"$DOMINIOS"; done
	sleep 1
	echo -e "Habilitando o Spam Filter"
	for DOMINIOS in $(/bin/cat /etc/userdomains | grep "$USUARIO" | awk -F: {'print $1'}); do /bin/cat filter.txt > /etc/vfilters/"$DOMINIOS"; done
	/bin/cat "$HOMEUSER"/filter.cache.txt > "$HOMEUSER"/.cpanel/filter.cache
	sleep 1
	/scripts/remove_dovecot_index_files --user="$USUARIO" --verbose
fi
