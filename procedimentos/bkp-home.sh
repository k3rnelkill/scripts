#!/bin/bash

HOMEBKP="$(cat /etc/passwd | grep $USER | awk -F: {'print $6'})"
DESTBKP="$HOMEBKP"/"Backup/"
USUARIO="$USER"

echo $USUARIO
echo $HOMEBKP
echo $DESTBKP
