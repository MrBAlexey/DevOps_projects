#!/usr/bin/env bash

function info {
    HOSTNAME=$(hostname)
    TIMEZONE=$(timedatectl show -p Timezone --value)
    TIMEZONE_UTC=$(date +"%:::z")
    USER=$(whoami)
    OS=$(cat /etc/os-release | grep PRETTY_NAME | cut -d "=" -f2 | tr -d '"')
    DATE=$(date +"%d %b %Y %H:%M:%S")
    UPTIME=$(uptime -p)
    UPTIME_SEC=$(cut -d '.' -f1 /proc/uptime)
    IP=$(hostname -I )
    MASK=$(ip -o -f inet addr show | awk '/scope global/ {print $4}' | cut -d'/' -f2 | head -n1)
    GATEWAY=$(ip route | awk '/default/ {print $3}')
    RAM_TOTAL=$(free -m | awk '/Mem/ {printf "%.3f GB\n", $2/1024}')
    RAM_USED=$(free -m | awk '/Mem/ {printf "%.3f GB\n", $3/1024}')
    RAM_FREE=$(free -m | awk '/Mem/ {printf "%.3f GB\n", $4/1024}')
    SPACE_ROOT=$(df -B1 | awk 'NR==2 {printf("%.2f MB\n", $2/1024/1024)}')
    SPACE_ROOT_USED=$(df -B1 | awk 'NR==2 {printf("%.2lf MB\n", $3/1024/1024)}')
    SPACE_ROOT_FREE=$(df -B1 | awk 'NR==2 {printf("%.2f MB\n", $4/1024/1024)}')   

system_data=$(cat -n <<-EOF
HOSTNAME = $HOSTNAME
TIMEZONE = $TIMEZONE UTC $TIMEZONE_UTC
USER = $USER
OS = $OS
DATE = $DATE
UPTIME = $UPTIME
UPTIME_SEC = $UPTIME_SEC
IP = $IP
MASK = $MASK
GATEWAY = $GATEWAY
RAM_TOTAL = $RAM_TOTAL
RAM_USED = $RAM_USED
RAM_FREE = $RAM_FREE
SPACE_ROOT = $SPACE_ROOT
SPACE_ROOT_USED = $SPACE_ROOT_USED
SPACE_ROOT_FREE = $SPACE_ROOT_FREE
EOF
)
}