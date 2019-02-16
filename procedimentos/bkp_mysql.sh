#!/bin/bash

#################################################################
#                                                               #
# Nome: bkp-mysql.sh                                            #
#                                                               #
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)           #
# Data: 10/01/19                                                #
#                                                               #
# Descrição: Faz um backup do banco do usuário informado        #
#                                                               #
# USO: ./bkp-mysql.sh                                           #
#                                                               #
#################################################################


SERVER=`hostname`
DIR="/root/bancobkp/"
LOG="/var/log/bkp_mysql.log"
DATA=`date +%Y-%m-%d_%H-%M-%S`;
DATAHORA=`date "+%d-%m-%Y %H:%M:%S"`;
ARQUIVO="backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"

#ALTERAR DADOS DE ACESSO AO BANCO
USUARIO="root"
SENHA="dementador"


#FUNCAO QUE FARA O BKP DB MYSQL
#comando=`for I in $(mysql -u $USUARIO -p$SENHA -e 'show databases' -s --skip-column-names | egrep -v  'information_schema|performance_schema|mysql'); do mysqldump --routines -u $usuario -p"$senha" $I > $DIR$I"_"$DATA".sql"; done`

comando=`for I in $(mysql -u $USUARIO -p$SENHA -e 'show databases' -s --skip-column-names | egrep -v  'information_schema|performance_schema|mysql'); do mysqldump --routines -u$USUARIO -p$SENHA $I > $DIR$I"_"$DATA".sql"; done`

#Faz Reparação de tabelas corrompidas.
reparar="mysqlcheck -A --auto-repair -u $USUARIO -p$SENHA"

#Inicia serviço
reinicia="service mysql restart"

#Apagando Backups antigos da pasta
#arquivos=`find $DIR* -type f -mtime 30 -exec rm -fv '{}' \;`

#INICIO
echo -e "\nIniciando Backup em $DATAHORA" >> $LOG;

#Verifica se diretorio existe, caso contrario cria-o.
if [ ! -d $DIR ]
then
	    echo "Criando o diretório $DIR ..." #>> $LOG
            mkdir -p $DIR
fi

echo -e "\nReparando tabelas que possam estar corrompidas $DATAHORA" #>> $LOG
$reparar

echo -e "\nReiniciando mysql $DATAHORA" #>> $LOG
$reinicia

echo -e "\nInciando dump das databases $DATAHORA" #>> $LOG
$comando;

#$echo "Removendo backup com +dias" >> $LOG
#$arquivos;

#Compactando arquivos
echo "Compactando Backup ..." #>> $LOG
tar zcvpf $DIR/$ARQUIVO --absolute-names --exclude="*tar.gz" --remove-files "$DIR"*
echo ""
echo -e "\nO backup de nome "$ARQUIVO" foi criado em $DIR" >> $LOG
echo "" 
echo -e "\nBackup Concluído!"
