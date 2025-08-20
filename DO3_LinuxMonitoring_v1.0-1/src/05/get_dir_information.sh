#!/usr/bin/env bash

get_info() {
    # #1. Общее количество папок
    total_folders=$(find "$DIR" -type d 2>/dev/null | wc -l)
    # #2. Топ 5 папок с самым большим весом
    top_five_folders=$(du -h "$DIR" 2>/dev/null | sort -hr | head -5 | awk '{printf("%d - %s, %s\n", NR, $2, $1)}')
    #3. Общее количество файлов 
    total_files=$(find "$DIR" -type f 2>/dev/null | wc -l)
    #4. Подсчёт файлов по типам
    total_conf_files=$(find "$DIR" -type f -name "*.conf" 2>/dev/null | wc -l)
    total_text_files=$(find "$DIR" -type f -iregex '.*\.\(txt\|md\)$' 2>/dev/null | wc -l)
    total_exec_files=$(find "$DIR" -type f -executable 2>/dev/null | wc -l)
    total_log_files=$(find "$DIR" -type f -name "*.log" 2>/dev/null | wc -l)
    total_archive_files=$(find "$DIR" -type f \( -iname "*.tar" -o -iname "*.gz" -o -iname "*.bz2" -o -iname "*.xz" -o -iname "*.zip" -o -iname "*.7z" -o -iname "*.rar" \) 2>/dev/null | wc -l)
    symbolic_links=$(find "$DIR" -type l 2>/dev/null | wc -l)
    #5. Подсчёт самых больших файлов и вывод по формату: путь, размер, расширение
    #Ищем по заданной дирректории файлы (find), передаём (-exec) в du, чтобы узнать размер, сортируем по убыванию (sort), первые 10 (head), передаём в awk для разделения и помещения в массив, отдаём для печати в printf, где NR - строка, ext - расширение   
    top_10_biggest_files=$(find "$DIR" -type f -exec du -b {} + 2>/dev/null | sort -hr |
                           head -n 10 | awk '{split($2, a, "."); ext=a[length(a)]; 
                           cmd="numfmt --to=iec " $1 cmd | getline size_human; close(cmd); 
                           printf("%d - %s, %s, .%s\n", NR, $2, size_human, ext)}'
                          )
    # 6. Топ-10 исполняемых файлов по размеру с хешем
    top_10_biggest_exec_files=$(find "$DIR" -type f -executable -exec du -b {} + 2>/dev/null |
                                 sort -hr | head -n 10 | awk '{hash_sum = "md5sum \"" $2 "\""; 
                                 hash_sum | getline hash_line; close(hash_sum); split(hash_line, 
                                 arr, " "); cmd="numfmt --to=iec " $1; cmd | getline size_human; 
                                 close(cmd); printf("%d - %s, %s, %s\n", NR, $2, size_human, arr[1])}'
                                )

    data=$(cat <<-EOF
Total numbers of folders (including all nested ones) = $total_folders
TOP 5 folders of maximum size arranged in descending order (path and size): 
$top_five_folders

Total number of files = $total_files
Number of:
Configuration files (with the .conf extension) = $total_conf_files
Text files = $total_text_files
Executable files = $total_exec_files
Log files (with the extension .log) = $total_log_files
Archive files = $total_archive_files
Symbolic links = $symbolic_links
TOP 10 files of maximum size arranged in descending order (path, size and type): 
$top_10_biggest_files

TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file): 
$top_10_biggest_exec_files
EOF
)
}