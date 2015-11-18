#!/bin/bash

for number in 211 114
do
    echo 147.2.207.$number:
    sshpass -p ${password} ssh root@147.2.207.${number} $@
done

for number in 54
do
    echo 10.162.2.$number:
    sshpass -p ${password} ssh root@10.162.2.${number} $@
done
