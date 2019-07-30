#!/bin/bash

USERCOLLECT="VAZIO"
NAMELIST="VAZIO"
TYPELIST="VAZIO"
USERDIRECTORY=`grep "$USERCOLLECT" /etc/passwd | cut -d: -f6`

read -p "Informe o usuário: " USERCOLLECT
read -p "Informe a lista - EX: listname_domain.com" NAMELIST
read -p "Informe o tipo da lista - EX: mbox ou normal" TYPELIST
