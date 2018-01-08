#!/bin/bash
set -eu

if [ -z $1 ];then
	exit
fi
if [ -z $2 ];then
	exit
fi

curl $1 | grep "^[0-9]" >a.log
curl $2 | grep "^[0-9]"  >b.log

paste [ab].log | awk '{if (NF==8) {print "Throughput(10^6bits/sec)", "\t", $4, "\t", $8, "\t", (1-($4/$8))*100, "%"}}'
