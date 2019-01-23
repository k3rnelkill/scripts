#!/bin/bash

SERVER=`hostname`
DIR="/root/backup/"
LOG_ERROR=/var/log/bkp_error.log
LOG=/var/log/bkp_mysql.log
DATA=`date +%Y-%m-%d-%H-%M-%S`;
DATAHORA=`date "+%d-%m-%Y %H:%M:%S"`;


#ALTERAR DADOS DE ACESSO AO BANCO
usuario="root"
senha=""

#BKP DB MYSQL
#Está sendo ignorando algumas bases do sistema com sed
comando=`for I in $(mysql -e 'show databases' -s --skip-column-names | sed '/information_schema/ d' | sed '/performance_schema/ d' | sed '/mysql/ d'); do mysqldump -u $usuario -p"$senha" $I > $DIR$I$DATA".sql"; done`

#Apagando Backups antigos da pasta
arquivos=`find $DIR* -type f -mtime 60 -exec rm -fv '{}' \;`


#INICIO
echo "Iniciando Backup em $DATA" >> $LOG;

#Verifica se diretorio existe, caso contrario cria-o.
if [ ! -d $DIR ]
then
    mkdir $DIR;
    echo "Diretorio criado com sucesso" >> $LOG;
fi




echo "Inciando dump das databases" >> $LOG
$comando;

echo "Removendo backup com +dias" >> $LOG
$arquivos;
