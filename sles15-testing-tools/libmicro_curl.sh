#!/bin/bash
set -eu

if [ -z $1 ];then
	exit
fi
if [ -z $2 ];then
	exit
fi

curl $1 | grep -v "^#"| grep -v "^Running" | grep -v "^ " | grep -v "^!" | grep "^[a-z]" | awk '{print $1,$4}' | grep -v "^cp:" >a.log
curl $2 | grep -v "^#"| grep -v "^Running" | grep -v "^ " | grep -v "^!" | grep "^[a-z]" | awk '{print $1,$4}' | grep -v "^cp:" >b.log

paste [ab].log | awk '{print $1, "\t",$2, "\t", $4, "\t",(1-($4/$2))*100,"%"}'
