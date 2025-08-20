#!/usr/bin/env bash
. ./color_selection.sh
. ./print_text.sh

if [[ "$color_bg1" == "$color_fg1" ]] || [[ "$color_bg2" == "$color_fg2" ]]
then
    echo "Error: The background color and the text color must not match."
else
    print_text
fi