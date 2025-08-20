#!/bin/bash

scp cat/s21_cat admin2@192.168.100.15:/usr/local/bin/ || exit 1
scp grep/s21_grep admin2@192.168.100.15:/usr/local/bin/ || exit 1

ssh admin2@192.168.100.15 ls -lah /usr/local/bin/
if [ $? -ne 0 ]; then
    echo "Ошибка при подключении по SSH"
    exit 1
fi
