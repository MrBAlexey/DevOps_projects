#!/usr/bin/env bash

print_param() {
    if [[ "$param" =~ ^-?[0-9] ]]
    then
        echo "Incorect input"
    else 
        echo "$param"
    fi
}