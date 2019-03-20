#!/bin/bash


TIMER=5

if [ $# -eq 0 ]
then
	echo "favor informar um processo como argumento."
	echo "scripts/procedimentos/MonitoraProcesso.sh <processo>"
	exit 1
fi

while true
do
	if ps axu | grep $1 | grep -v grep | grep -v $0 > /dev/null
	then
		sleep $TIME
	else
		echo "ATENÇÂO!!! O processo $1 não está em execução!"
		sleep $TIMER
	fi
done
