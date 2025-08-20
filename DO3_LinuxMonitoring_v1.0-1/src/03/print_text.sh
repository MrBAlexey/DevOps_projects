#!/usr/bin/env bash
. ./get_data.sh

bg_codes=( "" "\e[107m" "\e[41m" "\e[42m" "\e[44m" "\e[45m" "\e[40m" )
fg_codes=( "" "\e[97m"  "\e[31m" "\e[32m" "\e[34m" "\e[35m" "\e[90m" )
reset="\e[0m"

function print_text() {
    info
    while IFS= read -r line
    do
        before_eq="${line%%=*}"
        echo -en "${bg_codes[$1]}${fg_codes[$2]}$before_eq$reset = "
        after_eq="${line#*=}"
        echo -e "${bg_codes[$3]}${fg_codes[$4]}$after_eq$reset"
    done <<< "$system_data"
}