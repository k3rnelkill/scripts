#!/bin/bash

#COLORS
defaultColor="\033[0m"
red="\033[1;31m"

/scripts/update_local_rpm_versions --edit target_settings.clamav installed

echo -e "$red""\nInstalling the ClamAV RPM"$defaultColor""

sleep 2

/scripts/check_cpanel_rpms --fix --targets=clamav

echo -e "$red""\nCreting symbolic links clascan and freshcam\n"$defaultColor""

sleep 2

ln -s /usr/local/cpanel/3rdparty/bin/clamscan /usr/local/bin/clamscan
ln -s /usr/local/cpanel/3rdparty/bin/freshclam /usr/local/bin/freshclam

echo -e "$red""\nAdding database malware expert in freshclam.conf"$defaultColor""

sleep 2

echo "DatabaseCustomURL http://cdn.malware.expert/malware.expert.ndb
DatabaseCustomURL http://cdn.malware.expert/malware.expert.hdb
DatabaseCustomURL http://cdn.malware.expert/malware.expert.ldb
DatabaseCustomURL http://cdn.malware.expert/malware.expert.fp" >> /usr/local/freshclam.conf

echo -e "$red""\nRestarting and Updating freshclam\n"$defaultColor""

sleep 2
/usr/local/cpanel/3rdparty/bin/freshclam restart

echo -e "$red""\nCreating shortcurts scanl and scanr"$defaultColor""

sleep 2

echo "alias scanl='/usr/local/cpanel/3rdparty/bin/clamscan -ir'
alias scanr='/usr/local/cpanel/3rdparty/bin/clamscan -ir --remove=yes'" >> /root/.bashrc

echo -e "$red""\nprocedure completed."$defaultColor""
echo -e "$red""\nBye Bye!"$defaultColor""
