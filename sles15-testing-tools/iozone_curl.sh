#!/bin/bash
set -eu

if [ -z $1 ];then
	exit
fi
if [ -z $2 ];then
	exit
fi

curl $1 >a.log
curl $2 >b.log

./iozone.sh ./a.log 2>&1 >c.log

./iozone.sh ./b.log 2>&1 >d.log

paste [cd].log | awk '{print $1, $2, $3, $4, "\t", $5, "\t", $10, "\t", (1-($5/$10))*100,"%"}'
