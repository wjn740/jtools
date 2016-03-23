#!/bin/bash
set -eu

printf "%.2f\n" $(echo $(grep -n "$(head -n 1 /var/log/qaset/control/NEXT_RUN | awk -F " " '{print $2}')" qaset/list  | head -n 1 | awk -F ":" '{print $1}')/$(grep -v "[[:space:]]#.*$" qaset/list | wc -l)*100 | bc -l)
