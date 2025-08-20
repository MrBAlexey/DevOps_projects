#!/usr/bin/env bash
. ./get_data.sh
. ./color_selection.sh

function print_text() {
    info
    while IFS= read -r line
    do
        before_eq="${line%%=*}"
        echo -en "${color_bg1}${color_fg1}$before_eq${reset} = "
        after_eq="${line#*=}"
        echo -e "${color_bg2}${color_fg2}$after_eq${reset}"
    done <<< "$system_data"

    print_color_setting column1_background $default_bg1 "Column 1 background"
    print_color_setting column1_font_color $default_fg1 "Column 1 font color"
    print_color_setting column2_background $default_bg2 "Column 2 background"
    print_color_setting column2_font_color $default_fg2 "Column 2 font color"
}
