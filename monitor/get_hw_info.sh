#!/bin/bash
set -eu

#echo "Hostname" ';' 'Cores' ';' "Memory Size" ';' "Disk & Storage" ';' "NUMA nodes"
echo $(hostname) ";" $(ip a show dev eth0 | grep "inet " | awk '{print $2}') ";" $(echo $(lscpu | grep "Model name:" | awk -F ":" '{print $2}')) x$(lscpu | grep ^CPU\(s\): | awk -F ' ' '{print $2}') ";" $(dmidecode -t 17 | awk '( /Size/ && $2 ~ /^[0-9]+$/ ) { x+=$2 } END{ print x "MB"}') ";" $(lsscsi) ";" $(lspci -nn | grep Eth) ";" $(ls /sys/bus/node/devices/)
