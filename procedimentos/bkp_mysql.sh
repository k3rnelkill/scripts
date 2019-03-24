#!/bin/bash

#################################################################
#                                                               #
# Nome: bkp-mysql.sh                                            #
#                                                               #
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)           #
# Data: 10/01/19                                                #
#                                                               #
# Descrição: Faz um backup de todos os bancos e compacta        #
#                                                               #
# USO: ./bkp-mysql.sh                                           #
#                                                               #
#################################################################

#exec 1>> $LOG
exec 2>&1

SERVER=`hostname`
DIR="/root/bancobkp/"
LOG="/var/log/bkp_mysql.log"
DATA=`date +%Y-%m-%d_%H-%M-%S`;
DATAHORA=`date "+%d-%m-%Y %H:%M:%S"`;
ARQUIVO="backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"

#ALTERAR DADOS DE ACESSO AO BANCO
USUARIO="XXXXX"
SENHA="XXXXXXXXX"


#FUNCAO QUE FARA O BKP DB MYSQL
COMANDO=`for I in $(mysql -u $USUARIO -p$SENHA -e 'show databases' -s --skip-column-names | egrep -v  'information_schema|performance_schema|mysql'); do mysqldump --routines -u$USUARIO -p$SENHA $I > $DIR$I"_"$DATA".sql"; done`

#Faz Reparação de tabelas corrompidas.
REPARA="mysqlcheck -A --auto-repair -u $USUARIO -p$SENHA"

#Inicia serviço
REINICIA="service mysql restart"

#Lista arquivos que serão removidos
LISTA=`find $DIR* -type f -mtime +30 -exec ls -lash '{}' \;`
#Apagando Backups antigos da pasta
REMOVE=`find $DIR* -type f -mtime +30 -exec rm -fv '{}' \;`

#INICIO
echo -e "\nIniciando Backup em $DATAHORA" >> $LOG

#Verifica se diretorio existe, caso contrario cria-o.
if [ ! -d $DIR ]
then
	    echo "Criando o diretório $DIR ..." >> $LOG
            mkdir -p $DIR
fi

echo -e "\nReparando tabelas que possam estar corrompidas $DATAHORA" >> $LOG
$REPARA

echo -e "\nReiniciando mysql $DATAHORA" >> $LOG
$REINICIA

echo -e "\nInciando dump das databases $DATAHORA" >> $LOG
$COMANDO

echo -e "\nRemovendo backup com +dias" >> $LOG
$LISTA >> $LOG
$REMOVE

#Compactando arquivos e removendo os arquivos backpeados
echo -e "Compactando Backup ..." >> $LOG
tar zcvpf $DIR/$ARQUIVO --absolute-names --exclude="*tar.gz" --remove-files "$DIR"*
echo ""
echo -e "\nO backup de nome "$ARQUIVO" foi criado em $DIR" >> $LOG
echo "" 
echo -e "\nBackup Concluído!"
