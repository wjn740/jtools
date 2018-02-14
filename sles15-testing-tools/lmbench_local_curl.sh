#!/bin/bash
set -eu

if [ -z $1 ];then
	exit
fi
if [ -z $2 ];then
	exit
fi

curl $1 | grep "\*Local\* Communication latencies in microseconds - smaller is better" -A 5 | tail -n 1 >a.log
curl $2 | grep "\*Local\* Communication latencies in microseconds - smaller is better" -A 5 | tail -n 1 >b.log

paste [ab].log | awk -F "|" 'BEGIN{PIPE=0;AF_UNIX=0;UDP=0;TCP=0;TCP_CONN=0;}
											{print "Communication latencies in microseconds"; 
												print "PIPE(ms)", "\t", $2, "\t", $9, "\t", (1-($9/$2))*100, "%";
											print "AF_UNIX(ms)", "\t", $3, "\t", $10, "\t", (1-($10/$3))*100, "%";
											print "UDP(ms)", "\t", $4, "\t", $11, "\t", (1-($11/$4))*100, "%";
											print "TCP(ms)", "\t", $6, "\t", $13, "\t", (1-($13/$6))*100, "%";
											split($8, array, " ");
											print "TCP_CONN(ms)", "\t", array[1], "\t", $15, "\t", (1-($15/array[1]))*100, "%";
											}
											'
