#!/bin/bash

CURRENTYEAR=`date "+%Y"`
CURRENTMONTH=`date "+%b"`
MATURITYEAR=$(curl -v https://`hostname` 2>&1 | grep "expire date" | awk '{print $7}')
MONTH=$(curl -v https://`hostname` 2>&1 | grep "expire date" | awk '{print $4}')
CHECKDOMAIN=$(curl -v https://`hostname` > /dev/null 2>&1 ; echo $?)

echo "Ano atual $CURRENTYEAR"
echo "Ano vencimento $MATURITYEAR"
if [ $CHECKDOMAIN -eq 0 ]
then
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
else
	echo "Problemas de resulução"
fi
