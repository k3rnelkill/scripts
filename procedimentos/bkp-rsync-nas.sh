#!/bin/bash
#
# Coletando o hostname da maquina, backup serão enviados para um pasta com o mesmo nome!
SERVER=`hostname` 
# Diretório de Destino, local onde os backup serão armazenados.
NAS=/data/$SERVER/ 
# Gravando Logs de erros
LOG_ERROR=/var/log/bkp_error.log
# Gravando Logs
LOG=/var/log/bkp_nas.log
# Data
DIA=`date +%Y-%m-%d`;
# Data e Hora
DIAHORA=`date "+%d-%m-%Y %H:%M:%S"`;

#montando Disco NAS
echo "Montando particao do NAS" >> $LOG
mount -t nfs 0.0.0.16:/SUPERBIZ_NFS_VOL1/QTREE_SUPERBIZ_NFS_VOL1 $PARTICAO

echo "### "$DIAHORA" inicializando Backup ###" >> $LOG

#Sincronizando dados-backups

rsync -azh /var/site $NAS

#Atualiza Data/Hora
DIAHORA=`date "+%d-%m-%Y %H:%M:%S"`;
echo "### "$DIAHORA" finalizando Backup ###" >> $LOG

#Desmontando NAS
umount /data
