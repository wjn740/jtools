#!/bin/bash

for i in 1 2 3
do
    /usr/share/qa/tools/netperf-peer-fiber-run
    /usr/share/qa/tools/netperf-peer-fiber-run6
done
