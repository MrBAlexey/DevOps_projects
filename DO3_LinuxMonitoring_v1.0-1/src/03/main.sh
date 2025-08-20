#!/usr/bin/env bash

. ./print_text.sh

for arg in "$@"; do
    if ! [[ "$arg" =~ ^[1-6]$ ]] 
    then
        echo "Error: all parameters must be numbers from 1 to 6"
        exit 1
    fi
done

if [ $# -ne 4 ] 
then
    echo "Error: must be only 4 parameters!"
else
    if [ "$1" -eq "$2" ] || [ "$3" -eq "$4" ]
    then
        echo "Error: The background color and the text color must not match."
    else
        print_text $1 $2 $3 $4
    fi
fi
