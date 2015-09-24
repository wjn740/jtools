#!/bin/bash

for number in 210 211 209 163 114
do
    echo 147.2.207.$number:
    sshpass -p '${password}' ssh-copy-id root@147.2.207.${number}
done

for number in 53 54
do
    echo 10.162.2.$number:
    sshpass -p '${password}' ssh-copy-id root@10.162.2.${number}
done
