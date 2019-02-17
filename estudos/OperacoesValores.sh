#!/bin/bash

N1="0"
N2="0"

read -p "Informe o valor 1: " N1
read -p "Informe o valor 2: " N2

if [ ! $N1 ] || [ ! $N2 ]
then
	echo "Nenhum valor pode ser nulo!"
	exit 1
fi

echo ""
echo "Escolha uma Operação:"
echo "1 = Soma"
echo "2 = Subtração"
echo "3 = Multiplicação"
echo "4 = Divisão"
echo "Q = Sair"
echo ""
read -p "Opção: " OPCAO
echo ""

case $OPCAO in
	1)
		OPERACAO="+"
		;;
	2)
		OPERACAO="-"
		;;
	3)
		if [ $N1 -eq 0 -o $N2 -eq 0 ]
		then
			echo "Um valor 0 não pode ser utilizado em multiplicação"
			exit 1
		fi
		OPERACAO="*"
		;;
	4)
		if [ $N1 -eq 0 -o $N2 -eq 0 ]
		then
			echo "Um valor 0 não pode ser utilizado em divisão"
			exit 1
		fi

		if [ $(expr $N1 % $N2) -ne 0 ]
		then
			echo "Divisão com Resto = $(expr $N1 % $N2)"
		else
			echo "Divisão Exata"
		fi

		echo ""
		OPERACAO="/"
		;;
	Q)
		echo "Saindo..."
		exit
		;;
	*)
		echo "Opção inválida!"
		exit 1
		;;
esac

echo "$N1 $OPERACAO $N2 = $(expr $N1 "$OPERACAO" $N2)"
