#!/bin/bash
set -eu

if [ -z $1 ];then
	exit
fi
if [ -z $2 ];then
	exit
fi

curl -s $1 | egrep  '(^Number of threads|total time:)' | awk '{if ($1 == "Number"){ABC=$4;}; if ($1 == "total"){print ABC, $3}}' >a.log
curl -s $2 | egrep  '(^Number of threads|total time:)' | awk '{if ($1 == "Number"){ABC=$4;}; if ($1 == "total"){print ABC, $3}}' >b.log

paste [ab].log | awk '{print $1, "\t", $2, "\t", $4, "\t", (1-($4/$2))*100, "%"}'
#paste [ab].log
