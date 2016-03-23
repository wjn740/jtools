#!/bin/bash

for number in 210 211 209 163 114
do
    echo 147.2.207.$number:
    sshpass -p ${password} ssh root@147.2.207.${number} $@
done

for number in 166
do
    echo 147.2.208.$number:
    sshpass -p susetesting ssh root@147.2.208.${number} $@
done

for number in 53 54
do
    echo 10.162.2.$number:
    sshpass -p ${password} ssh root@10.162.2.${number} $@
done
