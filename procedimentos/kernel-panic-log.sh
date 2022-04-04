#!/usr/bin/env bash
#
# Script: Check KernelPanic
# Autor: Thiago Marques Dantas

IFSback=$IFS
IFS=$'\n'

LOG="/var/log/messages"
CMD_CAT=$(which cat)
CMD_GREP=$(which grep)
CMD_EGREP=$(which egrep)
CMD_TAIL=$(which tail)
CMD_ZABBIX_SENDER=$(which zabbix_sender)
CONF_ZABBIX_AGENT2="/etc/zabbix/zabbix_agent2.conf"

[ -z ${CMD_EGREP} ] && echo "The grep command does not exist" && exit 1
[ -z ${CMD_GREP} ] && echo "The grep command does not exist" && exit 1
[ -z ${CMD_CAT} ] && echo "The ps command does not exist" && exit 1
[ -z ${CMD_TAIL} ] && echo "The ps command does not exist" && exit 1
[ -z ${CMD_ZABBIX_SENDER} ] && echo "The zabbix_sender command does not exist" && exit 1

${CMD_TAIL} -n1000 ${LOG} | ${CMD_EGREP} "system_call"

if [ $(echo $?) -eq 0 ]
then
        echo "0 - achou alerta de kernel"
        ${CMD_ZABBIX_SENDER} -c ${CONF_ZABBIX_AGENT2} -s ${HOSTNAME} -k check.kernelpanic -o 0 
else
        echo "1 - nao achou"
        ${CMD_ZABBIX_SENDER} -c ${CONF_ZABBIX_AGENT2} -s ${HOSTNAME} -k check.kernelpanic -o 1
fi
