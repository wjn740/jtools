#!/bin/bash


for number in vh004 ph044 ph045
do
    echo ${number}.qa2.suse.asia:
    sshpass -p ${password} -- ssh -t root@${number}.qa2.suse.asia $@ &
done



wait
