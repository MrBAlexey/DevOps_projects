#!/usr/bin/env bash

. ./get_dir_information.sh

print_data() {
    get_info $DIR
    echo "$data"
}