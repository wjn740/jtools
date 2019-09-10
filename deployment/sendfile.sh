#!/bin/bash

for name in ph047 ph045 ph044 vh003 vh004
do
    echo ${name}.qa2.suse.asia:
    sshpass -p "${password}" scp -r $@ root@${name}.qa2.suse.asia:
done
