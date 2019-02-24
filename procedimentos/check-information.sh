#!/bin/bash

PROCESSOS="$(ps aux | wc -l)"
UPTIME="$(uptime)"
APACHEVERSION="$(httpd -v | grep "Server version")"
UPTIMEAPACHE="(service httpd fullstatus | grep "Server uptime")"
echo "========================================================"
echo -e             "Informações da Maquina"                  "
echo "========================================================"

echo -e "\nQuantidade de processos :$(("$PROCESSOS" - "1"))"
echo "UPTIME "$UPTIME""
echo -e "\nUptime APACHE "$UPTIMEAPACHE""
echo -e "\nVersão APACHE "$APACHEVERSION""
