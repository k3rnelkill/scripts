PROCESSOS=$((`ps aux | wc -l` - 1))
#PROCESSOS=`ps aux | wc -l`
UPTIME=`uptime`
APACHEVERSION=`httpd -v | grep "Server version"`
UPTIMEAPACHE=`service httpd fullstatus | grep "Server uptime"`
APACHEPROC=`service httpd fullstatus | grep "currently"`
PROCOCIOSO=`service httpd fullstatus | grep "idle workers"`

echo "========================================================"
echo "              Informações da Maquina                    "                  
echo "========================================================"

echo -e "\nQuantidade de processos: $PROCESSOS"
echo "UPTIME e LOAD: $UPTIME"

echo -e "\n==================================================="
echo    "           Informações sobre o APACHE                "
echo    "====================================================="

echo -e "\nUptime APACHE: $UPTIMEAPACHE"
echo -e "\nVersão APACHE: $APACHEVERSION"
echo -e "\nRequisições sendo processadas $APACHEPROC"
echo -e "\nProcessos ociosos $PROCOCIOSO"
