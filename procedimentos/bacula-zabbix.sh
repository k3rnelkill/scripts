#!/bin/bash

PASSWORD=$(grep "Password" /opt/bacula/etc/bacula-dir.conf | awk '{print $3}' | sed 's/\"//g')
SQLCHECK=$(mysql -NB -h localhost -ubacula -p$PASSWORD -Dbacula -e "SELECT JobId, FROM_UNIXTIME(JobTDate,'%d-%m-%Y') Job, Name, JobStatus ClientId FROM Job WHERE JobStatus<>'T';" | grep `date +%d-%m-%Y` | egrep -wv 'R|C')

if [ `echo $?` -eq 0 ]
then
       BACULA_CHECK='1';
       echo "$SQLCHECK" >> /var/log/bacula/bacula_errors.log
else
       BACULA_CHECK='0';
fi
/usr/bin/zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -s `hostname` -k bacula.backup -o $BACULA_CHECK;
