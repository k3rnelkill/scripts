#!/bin/bash

#DEFINES COLORS
DEFAULTCOLOR="\033[0m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"

LANGBKP=$LANG
LANG="en_US:en"
FILELOGPROCESSAMENT="/opt/hgmods/hg_processcount.log"
DAYNOW=$(/bin/date "+%b %d")
YEARNOW=$(/bin/date "+%Y")
FILEDOMAIN="/etc/trueuserdomains"
TMPFILE="/tmp/sumsend.tmp"
DIRQTDMAIL="/var/cpanel/email_send_limits/track/"

: '
echo $DAYNOW
echo $YEARNOW
echo $LANG
'

#BUSCA USUÁRIOS DETECTADOS COM ALTO CONSUMO DE PROCESSAMENTO.
grep -w -i "$DAYNOW" $FILELOGPROCESSAMENT | grep "$YEARNOW" | awk '{print $8}' | sed 's/(\|)//g' | sort | uniq -c | sort -nr | tee /tmp/high_processcount.txt

echo "+++++++++++++++++++++++++++++++++++++++++"

#RESTAURA O IDIOMA PADRÃO DO SISTEMA
LANG=$LANGBKP

#LAÇO UTILIZADO PARA COLETAR DADOS DE PROCESSAMENTO REGISTRADOS NO SERVIDOR.
for i in $(cat /tmp/high_processcount.txt | awk '{print $2}')
do      
        #COLLETA DOMINIO PRINCIPAL DO USUÁRIO
        DOMAIN=$(grep -w $i ${FILEDOMAIN} | awk -F\: '{print $1}')
       
        #CASO O DIRETÓRIO NÃO EXISTA, SIGNIFICA QUE NÃO HOUVE ENVIO DE E-MAIL, VALIDAÇÃO EVITA ERROS EXIBIDOS NO TERMINAL
        if [ -d ${DIRQTDMAIL}${DOMAIN}/ ]
        then
                #COLETA A QUANTIDADE DE EMAIL ENVIADOS POR DIA. AO CONTRARIO DO /ROOT/BIN/EC, ESTE PODE SER EXECUTADO EM 2seg SEM ELEVADOR O OIPS.
                SENDERCOUNTER=$(/bin/ls -l ${DIRQTDMAIL}${DOMAIN}/ | grep $(perl -e 'print join( ".", ( gmtime(time()) )[ 3, 4, 5 ] ) ') | awk '{print $5}' > ${TMPFILE} )
        else
                echo "0" > ${TMPFILE}
        fi

        : '
           INFORMATION ABOUNT VARIABLE COUNTER AND PASTE|BC COMMAND
           -d, --delimiters=LISTA  reutiliza caracteres da LISTA em vez de tabulações
           -s, --serial            cola um arquivo por vez em de todos em paralelo

           bc this a basic calculator      
        '
        #SOMA TODOS OS E-MAIL ENVIADOS DURANTE O DIA.
        COUNTER=$(paste -sd+ ${TMPFILE} | bc)

        #EXIBE USUÁRIO
        echo "Usuário: ${i}"

        #EXIBE O DOMÍNIO PRINCIPAL DA CONTA
        echo "Domínio Principal: ${DOMAIN}"

        #COLETA TODA AS CONTAS DE E-MAIL EXISTENTES, INDENPENDETE DO DOMÍNIO SER PRINCIPAL OU ADDONS
        echo "Número de contas de E-mail.: $(uapi --user=${i} Email list_pops | grep email | wc -l)"

        #EXIBE A SOMATÓRIO DE TODOS OS E-MAIL ENVIANDOS.
        echo "Qtd de e-mails enviados: ${COUNTER}"

        #EXIBE Q QUANTIDADE DE PICOS DE PROCESSAMENTO.
        echo "Número de Picos de processos: $(cat /tmp/high_processcount.txt | grep ${i} | awk '{print $1}')"

        #EXIBE O TOTAL DE BANDA UTILIZADO POR TODOS AS DOMÍNIOS DO USUÁRIO CPANEL
        echo "Banda em Bytes: $(whmapi1 showbw searchtype=user search=${i} | grep "totalbytes:" | sed "s/'//g" | awk '{print $2}')"
        echo "+++++++++++++++++++++++++++++++++++++++++"
done