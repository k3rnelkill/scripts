#!/bin/bash

#########################################################################################################################################
#                                                                                                                                       #
# Nome: enable_spamassassinv2.sh                                                                                                        #
#                                                                                                                                       #
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)                                                                                   #
# Data: 02/04/19                                                                                                                        #
#                                                                                                                                       #
# Descrição: Faz ativação do apachespamassassin e criação do filtro com algumas regras funcionas                                        #
#                 																														#
# Filtros estão padronizados em arquivos que podem ser alterados sem necessidade de modificar o código deste script. Assim sendo impleme#
# ntado nas proximas execuções.																											#			
#										                                                                                                #
# USO: ./enable_spamassassinv2.sh ou                                                                                                    #
# bash <( -ks https://raw.githubusercontent.com/marquesms/scripts/master/procedimentos/enable_spamassassinv2.sh)                        #
#                                                                                                                                       #
#########################################################################################################################################

USUARIO=`pwd | awk -F/ {'print $3'}`
HOMEUSER=`grep "$USUARIO" /etc/passwd | awk -F: {'print $6'}`
DIR="$HOMEUSER"/.spamassassin""
DATA=`date +%Y%m%d"_"%H%M`
#FILTRO=`wget https://raw.githubusercontent.com/marquesms/scripts/master/procedimentos/filter.txt -O "$HOMEUSER/filter.txt"`
FILTRO="https://raw.githubusercontent.com/marquesms/scripts/master/procedimentos/filter.txt"
#FILTRO2=`wget https://raw.githubusercontent.com/marquesms/scripts/master/procedimentos/filter2.txt -O "$HOMEUSER/filter.txt"`
#FILTRO2="https://raw.githubusercontent.com/marquesms/scripts/master/procedimentos/filter2.txt"
#CACHEFILTRO=`wget https://raw.githubusercontent.com/marquesms/scripts/master/procedimentos/filter.cache.txt -O "$HOMEUSER/filter.cache.txt"`
CACHEFILTRO="https://raw.githubusercontent.com/marquesms/scripts/master/procedimentos/filter.cache.txt"

#DEFININDO CORES
corPadrao="\033[0m"
verde="\033[1;32m"
vermelho="\033[1;31m"
branco="\033[1;37m"
amarelo="\033[1;33m"

echo $USUARIO
echo $HOMEUSER

if [ -f $HOMEUSER"/.spamassassinenable" ]
then

	echo -e ""$vermelho"\nJá existe um Spam Filter/ApacheSpamassassin Ativo."$corPadrao""
	echo -e ""$vermelho"\nDeseja sobrescrever a configuração?"$corPadrao""
	echo ""
	echo -e ""$verde"1 - SIM Sobrescrever"$corPadrao""
	echo -e ""$amarelo"2 - Aplicar somente o Filtros de SPAM"$corPadrao""
	echo ""
	echo -e ""$vermelho"3 - SAIR"$corPadrao""
	echo ""
	read -p "Opcao: " OPCAO
	echo ""

	case "$OPCAO" in
		1)          
			/usr/bin/wget $FILTRO -O "$HOMEUSER"/filter.txt
			/usr/bin/wget $CACHEFILTRO -O "$HOMEUSER"/filter.cache.txt
			echo ""$verde"Refazendo ativação padrão"$corPadrao""
			sleep 1
			uapi --user="$USUARIO" Email disable_spam_assassin
			echo -e ""$vermelho"\nResetando regras do whitelist, blacklist e etc"$corPadrao""
			echo "" > "$DIR""/user_prefs"
			echo -e ""$vermelho"\nHabilitando SpamAssassin/SpamFilter"$corPadrao""
			echo -e ""$verde"\nScore Spam 5.0"$corPadrao""
			sleep 1
			uapi --user="$USUARIO" Email enable_spam_assassin 
			uapi --user="$USUARIO" SpamAssassin update_user_preference preference=score value-0="ACT_NOW_CAPS 5.0"
			echo -e ""$verde"\nHabilitando auto Delete"$corPadrao""
			sleep 1
			cpapi1 --user="$USUARIO" Email enable_spam_autodelete
			echo -e ""$verde"Efetuando backup do vFilter"$corPadrao""
			for DOMINIOS in $(/bin/cat /etc/userdomains | grep "$USUARIO" | awk -F: {'print $1'}); do /bin/cp -pv /etc/vfilters/"$DOMINIOS" "$HOMEUSER"/"$DATA"_vfilter_"$DOMINIOS"; done
			sleep 1
			echo -e ""$verde"\nHabilitando o Filtros Globais"$corPadrao""
			for DOMINIOS in $(/bin/cat /etc/userdomains | grep "$USUARIO" | awk -F: {'print $1'}); do /bin/cat filter.txt > /etc/vfilters/"$DOMINIOS"; done
			/bin/cat "$HOMEUSER"/filter.cache.txt > "$HOMEUSER"/.cpanel/filter.cache
			echo -e ""$verde"\nLimpando os dovecot"$corPadrao""
			sleep 1
			/scripts/remove_dovecot_index_files --user="$USUARIO" --verbose
			echo -e ""$verde"\nFinalizado a implementação"$corPadrao""
			echo -e ""$vermelho"Dicas de melhorias para os filtros, Informe ao Gustavo Nogueira."$corPadrao""
			;;  
		2)  
			/usr/bin/wget $FILTRO -O "$HOMEUSER"/filter.txt
			/usr/bin/wget $CACHEFILTRO -O "$HOMEUSER"/filter.cache.txt
			echo -e ""$verde"\nScore Spam 5.0"$corPadrao""
			sleep 1
                        uapi --user="$USUARIO" SpamAssassin update_user_preference preference=score value-0="ACT_NOW_CAPS 5.0"
                        echo -e ""$verde"\nHabilitando auto Delete"$corPadrao""
			cpapi1 --user="$USUARIO" Email enable_spam_autodelete
			echo -e ""$verde"\nAplicando Filtros"$corPadrao""
			sleep 1		
			echo -e ""$verde"Efetuando backup do vFilter"$corPadrao""
			for DOMINIOS in $(/bin/cat /etc/userdomains | grep "$USUARIO" | awk -F: {'print $1'}); do /bin/cp -pv /etc/vfilters/"$DOMINIOS" "$HOMEUSER"/"$DATA"_vfilter_"$DOMINIOS"; done
			sleep 1
			echo -e "Habilitando o Spam Filter"
			for DOMINIOS in $(/bin/cat /etc/userdomains | grep "$USUARIO" | awk -F: {'print $1'}); do /bin/cat filter.txt > /etc/vfilters/"$DOMINIOS"; done
			/bin/cat "$HOMEUSER"/filter.cache.txt > "$HOMEUSER"/.cpanel/filter.cache
			sleep 1
			echo -e ""$verde"\nLimpando os dovecot"$corPadrao""
			/scripts/remove_dovecot_index_files --user="$USUARIO" --verbose
			echo -e ""$verde"\nFinalizado a implementação"$corPadrao""
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
	/usr/bin/wget $FILTRO -O "$HOMEUSER"/filter.txt
	/usr/bin/wget $CACHEFILTRO -O "$HOMEUSER"/filter.cache.txt
	echo -e ""$verde"\nAtivando SPAMASSASSIN do usuário "$USUARIO" ..."$corPadrao""
	sleep 1
	uapi --user="$USUARIO" Email enable_spam_assassin
	echo -e ""$verde"\nScore Spam 5.0"$corPadrao""
	sleep 1
	uapi --user="$USUARIO" SpamAssassin update_user_preference preference=score value-0="ACT_NOW_CAPS 5.0"
	echo -e ""$verde"\nHabilitando auto Delete"$corPadrao""
	sleep 1
	cpapi1 --user="$USUARIO" Email enable_spam_autodelete
	echo -e ""$verde"\nEfetuando backup do vFilter"$corPadrao""
	for DOMINIOS in $(/bin/cat /etc/userdomains | grep "$USUARIO" | awk -F: {'print $1'}); do /bin/cp -pv /etc/vfilters/"$DOMINIOS" "$HOMEUSER"/"$DATA"_vfilter_"$DOMINIOS"; done
	sleep 1
	echo -e ""$verde"\nHabilitando o Spam Filter"$corPadrao""
	for DOMINIOS in $(/bin/cat /etc/userdomains | grep "$USUARIO" | awk -F: {'print $1'}); do /bin/cat filter.txt > /etc/vfilters/"$DOMINIOS"; done
	/bin/cat "$HOMEUSER"/filter.cache.txt > "$HOMEUSER"/.cpanel/filter.cache
	sleep 1
	echo -e ""$verde"\nLimpando os dovecot"$corPadrao""
	/scripts/remove_dovecot_index_files --user="$USUARIO" --verbose
	echo -e ""$verde"\nFinalizado a implementação"$corPadrao""
fi
