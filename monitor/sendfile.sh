#!/bin/bash

for number in 210 211 209 163 114
do
    echo 147.2.207.$number:
    scp -r $@ root@147.2.207.${number}:
done

