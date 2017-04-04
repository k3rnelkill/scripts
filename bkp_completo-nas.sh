#!/bin/bash
#
# Coletando o hostname da maquina, backup serão enviados para um pasta com o mesmo nome!
SERVER=`hostname` 
SERVER="${SERVER/\.datatop\.com\.br/}"
# Diretório de Origem, local onde será gravado temporariamente o Backup.
DIR=/whm2/backup_automatizado/ 
# Diretório de Destino, local onde os backup serão armazenados.
NAS=/data/$SERVER/ 
# Gravado Logs de erros
LOG_ERROR=/var/log/bkp_error.log
# Gravando Logs
LOG=/var/log/bkp_nas.log
# Data
DIA=`date +%Y-%m-%d`;
# Data e Hora
DIAHORA=`date "+%d-%m-%Y %H:%M:%S"`;

#Contas que não serão backpeadas
EXCETO=("superews2com");

echo "\n### "$DIAHORA" inicializando Backup" >> $LOG

#atribui permissao para execucao do script
#chmod +x /usr/local/cpanel/scripts/pkgacct 

#Cria Pasta caso não exista e sincroniza com o NAS
if [ ! -d $DIR$DIA ]; then
	mkdir $DIR$DIA;
	echo "\nCriando pasta:  "$DIR$DIA >> $LOG;
	mkdir $NAS"/"$DIA;
	echo "\nCriando pasta:  "$NAS$DIA >> $LOG;
	rsync -avzh $DIR$DIA"/" $NAS$DIA"/";
fi

# Listando todos os usuario do Cpanel em ordem
for i in `cat /etc/trueuserowners | cut -d: -f1 | sort -n`; do 
    nome="${i//\/}";
    status=FALSE;

#Ignorando usuario excessão
    for x in ${EXCETO[@]}; do
	if [ $nome == $x ]; then
	    status=TRUE;
	    echo "!!! Ignorando Backup de $nome" >> $LOG;
	fi	
    done
    
 	#Gerando Backup na pasta de origem.   
    if [ $status == FALSE ]; then	
	echo "Gerando Backup de $nome";
	/usr/local/cpanel/bin/pkgacct $nome $DIR$DIA;
	
	#verifica se backup foi gerado
	if [ -e $DIR$DIA"/cpmove-"$nome".tar.gz" ]; then
		echo "\nBackupeando o arquivo: $nome " >> $LOG
		
		#Copiando o arquivo de backup para o NAS
		echo "\nEnviando cpmove-$nome.tar.gz para Bucket" >> $LOG;	
		cp -v $DIR$DIA"/cpmove-"$nome".tar.gz" $NAS$DIA"/";
		
		#Removendo arquivo de backup
		echo "\nRemovendo cpmove-$nome.tar.gz\n" >> $LOG;
		rm -f $DIR$DIA"/cpmove-"$nome".tar.gz";
	else
		echo "\n"$DIA"Erro ao fazer Backup da conta $nome " >> $LOG_ERROR;
	fi
    fi
done

#Removendo pasta do backup
rm -rf $DIR"/DIA";

#Atualiza Data/Hora
DIAHORA=`date "+%d-%m-%Y %H:%M:%S"`;
echo "\n### "$DIAHORA" finalizando Backup" >> $LOG