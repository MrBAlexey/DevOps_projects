#!/usr/bin/env bash

directory_path=$1
folders_counter=$2
folders_name=$3
files_counter=$4
files_name="${5%%.*}"
files_size=$6
files_extension="${5#*.}"
script_start_date=$(date '+%d%m%y')

folders_name_len=${#folders_name}
files_name_len=${#files_name}
files_extension_len=${#files_extension}

trash_folders_name="$folders_name"
trash_files_name="$files_name"
trash_files_extension_name="$files_extension"
finish_file_name=""
file=file_logs

last_folder_char=""
last_files_char=""

function check_param() {
    if [ ! -d "$directory_path" ]; then
        echo "Directory doesn't exist!"
        exit 1
    fi

    if [[ ! "$folders_counter" =~ ^-?[0-9]+$ ]] || [[ ! "$files_counter" =~ ^-?[0-9]+$ ]]; then
        echo "The number of nested directories and the number of files must be specified as integers!"
        exit 1
    fi

    if [ "$folders_name_len" -gt 7 ] || [ "$files_name_len" -gt 7 ] || [ "$files_extension_len" -gt 3 ]; then
        echo "Files name and folders name must be not more than 7 letters"
        exit 1
    fi

    if [[ ! "$folders_name" =~ ^[A-Za-z]+$ ]] || [[ ! "$files_name" =~ ^[A-Za-z]+$ ]]; then
        echo "Use only english letters"
        exit 1
    fi

    if [ "$files_size" -gt 100 ]; then
        echo "File size must be not more than 100kb"
        exit 1
    fi
}

function last_char() {
    last_folder_char=${folders_name: -1}
    last_files_char=${files_name: -1}
}

file_log() {
    local file_path="$1"
    local file_size_bytes=$(wc -c < "$file_path")
    local file_size_kb=$((file_size_bytes / 1024))

    echo -en "PATH: $file_path  \nDATE: " >> "$file"
    date +"%H:%M:%S %d-%m-%Y %Z %:z" >> "$file"
    echo "CONTENT: ${file_size_kb} KB" >> "$file"
}

function create_trash() {
    cd "$directory_path" || { echo "Failed to cd to $directory_path"; exit 1; }

    for (( i=0; i<folders_counter; i++ )); do
        trash_folders_name=$trash_folders_name$last_folder_char
        mkdir -p "$trash_folders_name"
        cd "$trash_folders_name" || exit 1
        echo "$trash_folders_name""_""$script_start_date"

        # Копируем переменную, чтобы не накапливать много символов
        local current_files_name="$trash_files_name"

        for (( y=0; y<files_counter; y++ )); do
            current_files_name=$current_files_name$last_files_char
            finish_file_name="$current_files_name""_""$script_start_date"
            touch "$finish_file_name"
            echo "$finish_file_name"
            file_log "$finish_file_name"
        done
        cd ..
    done
}

check_param
last_char
create_trash