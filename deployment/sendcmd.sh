#!/bin/bash


for name in ph047 ph044 ph045 vh004 vh003
do
    echo ${name}.qa2.suse.asia
    sshpass -p ${password} ssh root@${name}.qa2.suse.asia $@ &
done



wait
