#!/bin/bash

for number in ph044 ph045 vh004
do
    echo ${number}.qa2.suse.asia:
    sshpass -p "${password}" scp -r $@ root@${number}.qa2.suse.asia:
done

