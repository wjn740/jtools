#!/bin/bash

for number in 43 42 41 40 39 38 27 22 
do
    echo 10.67.130.$number:
    sshpass -p ${password} ssh root@10.67.130.${number} $@
done

for number in 11
do
    echo 10.67.131.$number:
    sshpass -p ${password} ssh root@10.67.131.${number} $@
done

for number in 53 54
do
    echo 10.162.2.$number:
    sshpass -p ${password} ssh root@10.162.2.${number} $@
done
