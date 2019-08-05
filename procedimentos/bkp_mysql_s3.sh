#!/bin/bash
################################################################## 
## Nome: bkp-mysql.sh                                            #
#                                                                #
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)            #
# Data: 04/08/19                                                 #
#                                                                #
# Descrição: Faz um backup de todos os bancos e compacta, monta  #
# partição do backup e envia dos dados                           #
#                                                                #
# USO: ./bkp-mysql.sh                                            #
#                                                                #
##################################################################
SERVER=`hostname`
RSYNC=`which rsync`
DIR="/root/bancobkp/"
DIRDEST=""
LOG="/var/log/bkp_mysql.log"
DATA=`date +%Y-%m-%d_%H-%M-%S`
DATAHORA=`date "+%d-%m-%Y %H:%M:%S"`
ARQUIVO="backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"
PARTICAOTMP="/mnt/bucket/"
BUCKET=""
S3FS=`/usr/bin/which s3fs`
DESMONTABUCKET=`/bin/fusermount -u`

#ALTERAR DADOS DE ACESSO DO BANCO
USUARIO=""
SENHA=""

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
$COMANDO;

echo "###########################################################################"
echo "Removendo backup com +dias" >> $LOG
$LISTA >> $LOG
echo "###########################################################################"
$REMOVE

#Compactando arquivos e removendo os arquivos backpeados
echo -e "\nCompactando Backup ..." >> $LOG
tar zcvpf $DIR/$ARQUIVO --absolute-names --exclude="*tar.gz" --remove-files "$DIR"*
echo ""
echo -e "\nO backup de nome "$DIR$ARQUIVO" foi criado em $DIR" >> $LOG
echo ""
echo -e "\nBackup Concluído "$DATAHORA"!" >> $LOG

#Sincronizando s3
echo -e "\nMontando bucket $DATAHORA" >> $LOG
$S3FS "$BUCKET" "$PARTICAOTMP"
echo -e "\nSincronizando na s3 $DATAHORA" >> $LOG

echo -e "\nSincrozanizando MySQL $DATAHORA"
$RSYNC -avzP $DIR $PARTICAOTMP$DIRDEST
sleep 2
echo -e "\nFinalizado sincronia do banco $DATAHORA" >> $LOG

echo -e "\nDesmontando bucket $DATAHORA" >> $LOG
$DESMONTABUCKET $BUCKET
