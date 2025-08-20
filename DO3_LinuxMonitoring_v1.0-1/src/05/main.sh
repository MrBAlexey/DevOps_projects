#!/usr/bin/env bash

. ./print_data.sh

start_script_time=$(date +%s.%N)
DIR="$1"

if [ $# -ne 1 ]
then
    echo "Must be only 1 parameter. Directory path absolute(/home/) or relative(../../.../home/)"
else
    if [ ! -d "$DIR" ]
    then
        echo "Directory $DIR doesn't exist"
    else
        if [[ "${DIR: -1}" != "/" ]]; then
            echo "Directory's path must ended: '/' "
        else
            print_data
        fi
    fi
fi
end_script_time=$(date +%s.%N)
runtime=$(echo "$end_script_time" - $start_script_time | bc)
echo "Script execution time (in seconds) = $runtime"
