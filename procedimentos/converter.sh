#!/bin/bash

maiscula () {
	echo $1 | tr a-z A-Z
}

minuscula () {
	echo $1 | tr A-Z a-z
}

read -p "Informe o arquivo... " ARQUIVO
TEMP=$ARQUIVO

for line in $(cat "$ARQUIVO")
do
	VAR1=$(minuscula $line)
	echo $VAR1
	echo $VAR1 >> $TEMP\."txt"
done
