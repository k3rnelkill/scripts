#!/bin/bash
################################################################## 
## Nome: bkp-mysql.sh                                            #
#                                                                #
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)            #
# Data: 04/08/24                                                 #   
# Requisitos: Possuir s3cmd instalado e chaves IAM do buket       #
# Descrição: Faz um backup de todos os bancos e compacta, monta  #
# partição do backup e envia dos dados                           #
#                                                                #
# USO: ./bkp_mysql_s3.sh                                         #
#                                                                #
##################################################################
SERVER=`hostname`
DIR="/tmp/bancobkp/"
LOG="/var/log/bkp_mysql.log"
DATA=`date +%Y-%m-%d_%H-%M-%S`
DATAHORA=`date "+%d-%m-%Y %H:%M:%S"`
ARQUIVO="backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"
BUCKET="s3://wemarkenting/server01.drfabiosaad.com.br/"
CMD_AWSCLI=`which aws`


#ALTERAR DADOS DE ACESSO DO BANCO
USUARIO="root"
SENHA="*********"


[ ! -x "${CMD_AWSCLI}" ] && echo "AWS CLI não encontrado!" && exit 1

#INICIO
echo -e "\nIniciando Backup em $DATAHORA" >> $LOG

#Verifica se diretorio existe, caso contrario cria-o.
if [ ! -d $DIR ]
then
            echo "Criando o diretório $DIR ..." >> $LOG
            mkdir -pv $DIR
fi

sleep 5

#FUNCAO QUE FARA O BKP DB MYSQL
for I in $(mysql -u $USUARIO -p$SENHA -e 'show databases' -s --skip-column-names | egrep -v 'information_schema|performance_schema|mysql'); do
    mysqldump --routines -u$USUARIO -p$SENHA $I > $DIR$I"_"$DATA".sql"
done


#Compactando arquivos e removendo os arquivos backpeados
echo -e "\nCompactando Backup ..." >> $LOG
tar zcvpf $DIR/$ARQUIVO --exclude="*tar.gz" --remove-files "$DIR"*
sleep 5
echo ""
echo -e "\nO backup de nome "$DIR$ARQUIVO" foi criado em $DIR" >> $LOG
echo ""
echo -e "\nBackup Concluído "$DATAHORA"!" >> $LOG

#Sincronizando s3
"${CMD_AWSCLI}" s3 sync $DIR $BUCKET
echo -e "\nSincronizando na s3 $DATAHORA" >> $LOG
sleep 5

rm -fv $DIR*.gz
echo -e "\nFinalizado sincronia do banco $DATAHORA" >> $LOG
