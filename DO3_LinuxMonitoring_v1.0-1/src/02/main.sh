#!/usr/bin/env bash
. ./get_data.sh
file=$(date +'%d_%m_%Y_%H_%M_%S').status 
info
echo "$system_data"
read -t 10 -p $'Would you like to save data? (yY\\nN)\n' answer

case $answer in
    [yY]) echo "$system_data" > $file
    echo "Data save in $file";;
    *) echo "Data isn't saved";;
esac