#!/bin/bash
set -eu

if [ -z $1 ];then
	exit
fi
if [ -z $2 ];then
	exit
fi

curl $1 | grep "Throughput .* max_latency.*$" | awk '{print $0}' | grep -v "^cp:" >a.log
curl $2 | grep "Throughput .* max_latency.*$" | awk '{print $0}' | grep -v "^cp:" >b.log

paste [ab].log | awk '{print $6, $7, $1,"(",$3,")", "\t", $2,  "\t",$11, "\t",(1-($2/$11))*100,"%"; 
											split($8, array, "="); 
											split($17, arrayB, "=");
											print $6, $7, array[1], $9, "\t", array[2], "\t", arrayB[2], "\t", (1-(arrayB[2]/array[2]))*100,"%";}'

