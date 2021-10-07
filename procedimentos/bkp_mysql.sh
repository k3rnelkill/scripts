#!/usr/bin/env bash
################################################################## 
## Nome: bkp-mysql.sh                                            #
#                                                                #
# Autor: Thiago Marques (thiagomarquesdums@gmail.com)            #
# Data: 07/10/21                                                 #
#                                                                #
# Descrição: Faz um backup de todos os bancos e compacta         #
#                                                                #
# USO: /root/scripts/bkp-mysql.sh                                #
#                                                                #
##################################################################

CMD_TAR=$(which tar)
CMD_DATE=$(which date)
CMD_MKDIR=$(which mkdir)

DIR="/dbBackup/"
LOG="/var/log/bkp_mysql.log"
DATA=`${CMD_DATE} "+%Y-%m-%d"`
DATAHORA=`${CMD_DATE} "+%d-%m-%Y %H:%M:%S"`
ARQUIVO="backup_`${CMD_DATE} +%Y-%m-%d`.tar.gz"

#ALTERAR DADOS DE ACESSO DO BANCO
USUARIO="root"
SENHA=""

[ ! -e ${CMD_TAR} ] && echo "O comando informado não existe" && exit 1
[ ! -e ${CMD_DATE} ] && echo "O comando informado não existe" && exit 1
[ ! -e ${CMD_MKDIR} ] && echo "O comando informado não existe" && exit 1
[ ! -d ${DIR} ] && echo "Diretorio informado não existe" && mkdir -pv ${DIR}

#FUNCAO QUE FARA O BKP DB MYSQL
COMANDO=`for I in $(mysql -u $USUARIO -p$SENHA -e 'show databases' -s --skip-column-names | egrep -v  'information_schema|system|performance_schema|mysql'); do mysqldump --routines -u$USUARIO -p$SENHA $I > $DIR$I"_"$DATA".sql"; done`

#INICIO
echo -e "\nIniciando Backup em $DATAHORA" >> $LOG

echo -e "\nIniciando dump das databases $DATAHORA" >> $LOG
${COMANDO};

#COMPACTANDO BACKUP E REMOVENDO .SQL
echo -e "\nCompactando Backup ..." >> $LOG
${CMD_TAR} zcvpf $DIR/$ARQUIVO --absolute-names --exclude="*tar.gz" --remove-files "$DIR"*
echo ""
echo -e "\nO backup de nome "$DIR$ARQUIVO" foi criado em $DIR" >> $LOG
echo ""
echo -e "\nBackup Concluído "$DATAHORA"!" >> $LOG
