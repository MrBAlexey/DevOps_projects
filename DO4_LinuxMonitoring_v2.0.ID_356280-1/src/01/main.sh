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
file=../file_logs.txt

last_folder_char=""
last_files_char=""



function check_param() {
    # #0 проверка на количество параметров
    # if [ "$#" -ne 6 ]
    # then
    #     echo "Must be only 6 parameters"
    #     exit 1
    # fi

    #1 проверка на существование пути
    if [ ! -d "$directory_path" ]
    then
        echo "Directory doesn't exist!"
        exit 1
    fi

    #2 проверка, что задано числовое значение
    #4 проверка, что задано числовое значение
    if [[ ! "$folders_counter" =~ ^-?[0-9]+$ ]] || [[ ! "$files_counter" =~ ^-?[0-9]+$ ]]
    then
        echo "The number of nested directories and the number of files must be specified as integers!"
        exit 1
    fi

    #3 проверка на корректность названия папок, английский алфавит не более 7
    #5 проверка на корректность названия файлов, английский алфавит не более 7 символов для файла не более 3 для расширения

    if [ "$folders_name_len" -gt 7 ] || [ "$files_name_len" -gt 7 ] || [ "$files_extension_len" -gt 3 ]
    then echo "Files name and folders name must be not more than 7 letters"
        exit 1
    fi

    if [[ ! "$folders_name" =~ ^[A-Za-z]+$ ]] || [[ ! "$files_name" =~ ^[A-Za-z]+$ ]]
    then
        echo "Use only english letters"
        exit 1
    fi

    #6 проверка, что задано числовое значение, не больше 100
    if [ "$files_size" -gt 100 ]
    then
        echo "File size must be not more than 100kb"
        exit 1
    fi
}

function last_char() {

    for (( i=0; i<folders_name_len; i++ )) 
    do
        if [[ $((i+1)) -eq $folders_name_len ]]
        then
            last_folder_char=${folders_name:i:1}
        fi
    done

    for (( i=0; i<files_name_len; i++ )) 
    do
            if [[ $((i+1)) -eq $files_name_len ]]
        then
            last_files_char=${files_name:i:1}
        fi
    done
}


file_log() {
    file_size_bytes=$(wc -c < $finish_file_name)
    file_size_kb=$((file_size_bytes / 1024))
    
    echo -en "PATH: $1  \nDATE: " >> $file
    date +"%H:%M:%S %d-%m-%Y %Z %:z" >> $file
    echo "CONTENT: $file_size_kb " >> $file
    new_line ../file_logs.txt
}


new_line() {
#ЭТА ФУНКЦИЯ НЕ РАБОТАЕТ, так как это было задумано, если последняя строка не пустая - отступ не делается
    if [ ! -z "$(tail -n 1 $1)" ]
    then
        echo "" >> $1
    fi
    # ! -z "$(tail -n 1 $1)"- проверяет что последняя строка не пустая
}


function create_trash() {
    for (( i=0; i<folders_counter; i++ ))
    do
        trash_folders_name=$trash_folders_name$last_folder_char
        mkdir $trash_folders_name
        cd $trash_folders_name
        # echo "$trash_folders_name""_""$script_start_date"

        for (( y=0; y<files_counter; y++ ))
        do
            trash_files_name=$trash_files_name$last_files_char
            finish_file_name="$trash_files_name""_""$script_start_date"".""$files_extension"
            touch $finish_file_name
            # echo "$finish_file_name"
            file_log $finish_file_name
        done
        cd ./..
    done
}

check_param
last_char
create_trash

# file_creating_no_param() {
#         if [ ! -f myFile.txt ]
#     then
#         touch myFile.txt
#         chmod 777 myFile.txt
#     else
#         fileName="myFile-$(date +'%H_%M_%S--%d-%m-%Y').txt"
#         touch "$fileName"
#         chmod 777 "$fileName"
#     fi
# }

# file_creating_01_param() {
#     if [ ! -f $1 ]
#     then
#         touch $1
#         chmod 777 $1 
#     fi
#     # ! -f - проверяет существование файла
# }


# case "$#" in 
#     0) file_creating_no_param
#         new_line "myFile.txt";;
#     1) file_creating_01_param "$1"
#         new_line "myFile.txt";;
#     2) file_creating_01_param "$1"
#         new_line "myFile.txt"
#         file_log "$1" "$2";;
# esac



# if [ $# -ne 0 ]
# then
#     if [ ! -f $1 ]
#     then
#         touch $1 
#         chmod 777 $1 
#     fi
#     # ! -f - проверяет существование файла

#     if [ -n "$(head -n 1 $1)" ]
#     then
#         echo -en "\n" >> $1
#     fi
#     # -n "$(head -n 1 $1)"- проверяет что 1я строка не пустая

#     echo -n "$(basename "$2") - " >> $1
#     date +"%H:%M:%S %d-%m-%Y %Z %:z">> $1
# else
#     if [ ! -f myFile.txt ]
#     then
#         touch myFile.txt
#         chmod 777 myFile.txt
#     else
#         fileName="myFile.txt-$(date +'%H-%M-%S_%d-%m-%Y')"
#         touch "$fileName"
#         chmod 777 "$fileName"
#     fi
# fi