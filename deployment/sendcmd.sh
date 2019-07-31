#!/bin/bash


for name in ph047 ph044 ph045
do
    echo ${name}.qa2.suse.asia
    sshpass -p ${password} ssh root@${name}.qa2.suse.asia $@ &
done



wait
