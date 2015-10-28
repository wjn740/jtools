#!/bin/bash
#211 209
for number in 210 163 114
do
    echo 147.2.207.$number:
    sshpass -p susetesting ssh root@147.2.207.${number} $@ &
done

for number in 53 54
do
    echo 10.162.2.$number:
    sshpass -p susetesting ssh root@10.162.2.${number} $@ &
done
