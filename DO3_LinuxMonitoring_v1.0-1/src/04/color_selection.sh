#!/usr/bin/env bash
. ./config.cfg

bg_color=( "" "\e[107m" "\e[41m" "\e[42m" "\e[44m" "\e[45m" "\e[40m" )
fg_color=( "" "\e[97m"  "\e[31m" "\e[32m" "\e[34m" "\e[35m" "\e[90m" )
reset="\e[0m"

default_bg1=1
default_fg1=6
default_bg2=6
default_fg2=1

bg1_num=${column1_background:-$default_bg1}
fg1_num=${column1_font_color:-$default_fg1}
bg2_num=${column2_background:-$default_bg2}
fg2_num=${column2_font_color:-$default_fg2}

color_bg1="${bg_color[$bg1_num]}"
color_fg1="${fg_color[$fg1_num]}"
color_bg2="${bg_color[$bg2_num]}"
color_fg2="${fg_color[$fg2_num]}"

declare -A colors=(
    [1]="white"
    [2]="red"
    [3]="green"
    [4]="blue"
    [5]="purple"
    [6]="black"
)

function print_color_setting() {
    local var_name=$1
    local default_val=$2
    local label=$3
    local val=${!var_name}  # косвенная подстановка

    if [ -z "$val" ] 
    then
        echo "$label = default (${colors[$default_val]})"
    else
        echo "$label = $val (${colors[$val]})"
    fi
}