#!/bin/bash

echo "------------------------------------------------------"
echo "Beijing Servers:"
echo "------------------------------------------------------"
for number in 210 211 209 163 114
do
    echo 147.2.207.$number:
    sshpass -p susetesting ssh root@147.2.207.${number} screen -ls
done

echo "------------------------------------------------------"
echo "Nuermberg Servers:"
echo "------------------------------------------------------"

for number in 54 53
do
    echo 10.162.2.$number:
    sshpass -p susetesting ssh root@10.162.2.${number} screen -ls
done
