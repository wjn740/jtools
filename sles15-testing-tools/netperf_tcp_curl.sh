#!/bin/bash
set -eu

if [ -z $1 ];then
	exit
fi
if [ -z $2 ];then
	exit
fi

curl $1 | grep "^ " >a.log
curl $2 | grep "^ "  >b.log

paste [ab].log | awk '{print "Throughput(10^6bits/sec)", "\t", $5, "\t", $10, "\t", (1-($5/$10))*100, "%"}'
