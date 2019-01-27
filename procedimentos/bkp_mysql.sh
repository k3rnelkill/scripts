#!/bin/bash

SERVER=`hostname`
DIR="/root/bancobkp/"
LOG_ERROR=/var/log/bkp_error.log
LOG=/var/log/bkp_mysql.log
DATA=`date +%Y-%m-%d-%H-%M-%S`;
DATAHORA=`date "+%d-%m-%Y %H:%M:%S"`;


#ALTERAR DADOS DE ACESSO AO BANCO
usuario="root"
senha="7W8Ktx0Hpppq"

#BKP DB MYSQL
#Está sendo ignorando algumas bases do sistema com sed
#comando=`for I in $(mysql -u $usuario -p$senha -e 'show databases' -s --skip-column-names | sed '/information_schema/ d' | sed '/performance_schema/ d' | sed '/mysql/ d'); do mysqldump -u $usuario -p"$senha" $I > $DIR$I"_"$DATA".sql"; done`
#adicionando --routines para exportar procedures
comando=`for I in $(mysql -u $usuario -p$senha -e 'show databases' -s --skip-column-names | egrep -v  'information_schema|performance_schema|mysql'); do mysqldump --routines -u $usuario -p"$senha" $I > $DIR$I"_"$DATA".sql"; done`

#Faz Reparação de tabelas corrompidas.
reparar=`mysqlcheck -A --auto-repair -u root -p$senha`

#Inicia serviço
reinicia=service mysql restart

#Apagando Backups antigos da pasta
#arquivos=`find $DIR* -type f -mtime 30 -exec rm -fv '{}' \;`

#INICIO
echo -e "\nIniciando Backup em $DATAHORA" >> $LOG;

#Verifica se diretorio existe, caso contrario cria-o.
if [ ! -d $DIR ]
then
    mkdir $DIR;
    echo "Diretorio criado com sucesso" >> $LOG;
fi

echo -e "\nReparando tabelas que possam estar corrompidas $DATAHORA" >> $LOG
$reparar

echo -e "\nReiniciando mysql $DATAHORA" >> $LOG
$reinicia

echo -e "\nInciando dump das databases $DATAHORA" >> $LOG
$comando;

echo "Removendo backup com +dias" >> $LOG
$arquivos;
