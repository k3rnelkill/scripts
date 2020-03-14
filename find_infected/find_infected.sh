#!/bin/bash

NAMESERVER=$(uname -n)
#LISTA DE USUÁRIOS POSSIVELMENTE INFECTADO
LISTUSERS="/tmp/list_user.tmp"
#LOGS COM DADOS DA SCAN
RELATSCAN="/tmp/relatorio_scan.txt"

#REMOVENDO ARQUIVOS TEMPORARIOS CASO EXISTA
[ -f ${LISTUSERS} ] && rm -f ${LISTUSERS:-VAZIO}

#BUSCA ARQUIVOS MALICIOSOS SOMENTE NA INDEX
grep "\@include" /home/*/public_html/index.php | grep "\x" | awk -F\/ '{print $3}' | uniq > ${LISTUSERS} ; cat ${LISTUSERS}

sleep 5

for i in $(cat ${LISTUSERS})
do
        echo "++++++++++++++++++++++++++++++" >> ${RELATSCAN}
        cd /home/${i}
        pwd | tee -a ${RELATSCAN}
        /usr/local/cpanel/3rdparty/bin/clamscan -ir . | tee /home/${i}/malware.txt
        echo ${i} >> ${RELATSCAN}
        grep "Infected files:" /home/${i}/malware.txt | head -n1 >> ${RELATSCAN}

        if [ $(grep "Infected files:" /home/${i}/malware.txt | head -n1 | awk '{print $3}') -ge "0" ]
        then
                echo "Arquivos infectado[s] encontrado." >> ${RELATSCAN}
        else
                echo "Falso positivo." >> ${RELATSCAN}
                echo "Qtd Malware 0" >> ${RELATSCAN}
        fi
done

#ENVIO DO RELATÓRIO
mail -s "${NAMESERVER} RELATÓRIO DE SCAN" thiagogardenajj@gmail.com < ${RELATSCAN}
