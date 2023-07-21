#!/usr/bin/env bash
#
# Script: sysPass - Backup
# Autor: Thiago Dantas

CMD_DATE=$(which date)
CMD_MARIADB=$(which mariadb)
CMD_MARIADB_DUMP=$(which mariadb-dump)
CMD_RM=$(which rm)
CMD_SHA256SUM=$(which sha256sum)
CMD_SYNC=$(which sync)
CMD_TAR=$(which tar)
DIR_BACKUP_ETC="/syspassbackup/etc"
DIR_BACKUP_SYSPASS_CONFIG="/syspassbackup/syspass-config"
DIR_BACKUP_SYSPASS_MARIADB="/syspassbackup/syspass-mariadb"
DIR_BACKUP_SYSPASS_MARIADB_COMPRESSED="/syspassbackup/syspass-mariadb-compressed"
DIR_ETC="/etc"
DIR_SYSPASS_CONFIG="/var/www/html"
SCRIPT_CLEANER="/root/scripts/cleaner.sh"
SCRIPT_CLEANER_SESSION="/root/scripts/cleaner-session.sh"

[ ! -e "${CMD_DATE}" ] && echo "The date command does not exist" && exit 1
[ ! -e "${CMD_MARIADB}" ] && echo "The mariadb command does not exist" && exit 1
[ ! -e "${CMD_MARIADB_DUMP}" ] && echo "The mariadb-dump command does not exist" && exit 1
[ ! -e "${CMD_RM}" ] && echo "The rm command does not exist" && exit 1
[ ! -e "${CMD_SHA256SUM}" ] && echo "The sha256sum command does not exist" && exit 1
[ ! -e "${CMD_SYNC}" ] && echo "The sync command does not exist" && exit 1
[ ! -e "${CMD_TAR}" ] && echo "The tar command does not exist" && exit 1
[ ! -d "${DIR_BACKUP_ETC}" ] && echo "The dir backup etc does not exist" && exit 1
[ ! -d "${DIR_BACKUP_SYSPASS_CONFIG}" ] && echo "The dir backup syspass config does not exist" && exit 1
[ ! -d "${DIR_BACKUP_SYSPASS_MARIADB}" ] && echo "The dir backup syspass mariadb does not exist" && exit 1
[ ! -d "${DIR_BACKUP_SYSPASS_MARIADB_COMPRESSED}" ] && echo "The dir backup syspass mariadb compressed does not exist" && exit 1
[ ! -d "${DIR_ETC}" ] && echo "The dir etc does not exist" && exit 1
[ ! -d "${DIR_SYSPASS_CONFIG}" ] && echo "The dir syspass config does not exist" && exit 1
[ ! -e "${SCRIPT_CLEANER}" ] && echo "The script cleaner does not exist" && exit 1
[ ! -e "${SCRIPT_CLEANER_SESSION}" ] && echo "The script cleaner session does not exist" && exit 1

"${SCRIPT_CLEANER}"
"${SCRIPT_CLEANER_SESSION}"

DUMP_DATE=$("${CMD_DATE}" "+%F")

for m in $("${CMD_MARIADB}" -e 'show databases' -s --skip-column-names | egrep -v "information_schema|performance_schema");
do
        "${CMD_SYNC}"
        "${CMD_MARIADB_DUMP}" --events --routines --triggers "${m}" > "${DIR_BACKUP_SYSPASS_MARIADB}"/"${m}"-"${DUMP_DATE}".sql
        cd "${DIR_BACKUP_SYSPASS_MARIADB}"
        "${CMD_SHA256SUM}" -b "${m}"-"${DUMP_DATE}".sql > "${m}"-"${DUMP_DATE}".sha256
done

"${CMD_SYNC}"

"${CMD_TAR}" -zcf "${DIR_BACKUP_ETC}"/etc-"${DUMP_DATE}".tar.gz "${DIR_ETC}"
"${CMD_TAR}" -zcf "${DIR_BACKUP_SYSPASS_CONFIG}"/syspass-config-"${DUMP_DATE}".tar.gz "${DIR_SYSPASS_CONFIG}"
"${CMD_TAR}" -zcf "${DIR_BACKUP_SYSPASS_MARIADB_COMPRESSED}"/syspass-mariadb-"${DUMP_DATE}".tar.gz "${DIR_BACKUP_SYSPASS_MARIADB}"

"${CMD_RM}" -fv "${DIR_BACKUP_SYSPASS_MARIADB}"/*.sql
"${CMD_RM}" -fv "${DIR_BACKUP_SYSPASS_MARIADB}"/*.sha256

"${CMD_SYNC}"
