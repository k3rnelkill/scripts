#!/bin/bash

CURRENTYEAR=`date "+%Y"`
CURRENTMONTH=`date "+%b"`
MATURITYEAR=`curl -v https://`hostname` 2>&1 | grep "expire date" | awk '{print $7}'`
MONTH=`curl -v https://`hostname` 2>&1 | grep "expire date" | awk '{print $4}'`


echo "Ano atual $CURRENTYEAR"
echo "Ano vencimento $MATURITYEAR"

if [ $CURRENTYEAR -lt $MATURITYEAR ]
then
	echo "Fora do ano de vencimento de vencimento"
	echo "Mês = $MONTH"
else 
	echo "Certificado vencera este ano."
	echo "Mês = $MONTH"
	if [ $MONTH = $CURRENTMONTH ]
	then
		echo "Certificado vencerá esse mês"
	else
		echo "Fora do mês de vencimento"
	fi
fi
