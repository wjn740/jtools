#!/bin/bash
set -eu

if [ -z $1 ];then
	exit
fi
if [ -z $2 ];then
	exit
fi

curl -s $1 | egrep  '(^tps|clients)' | grep -v "includ" | awk '{if ($1 == "number"){ABC=$3;WJN=$4}; if ($1 == "tps"){print ABC, WJN, $3}}' >a.log
curl -s $2 | egrep  '(^tps|clients)' | grep -v "includ" | awk '{if ($1 == "number"){ABC=$3;WJN=$4}; if ($1 == "tps"){print ABC, WJN, $3}}' >b.log

paste [ab].log | awk '{print $1, $2, $3, $6, (1-($6/$3))*100}'
