#!/bin/bash

#211
for number in 211 114
do
    echo 147.2.207.$number:
    sshpass -p ${password} ssh root@147.2.207.${number} "yast virtualization"
    sshpass -p ${password} ssh root@147.2.207.${number} "yast kdump"
done

for number in 54
do
    echo 10.162.2.$number:
    sshpass -p ${password} ssh root@10.162.2.${number} "yast virtualization"
    sshpass -p ${password} ssh root@10.162.2.${number} "yast kdump"
done


wait
