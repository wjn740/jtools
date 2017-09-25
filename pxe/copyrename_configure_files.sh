#!/bin/bash
#set -eu

if [ "${1}X" == "X" ]; then
	echo "usage: $0 <oldfilename> <newfilename>"
	exit
fi
#for f in `ls SLE15-Alpha4*`
for f in `ls ${1}*`
do
	newname=$(echo $f | sed "s/$1/$2/g")
	echo ${newname}
	if [ -f "${newname}" ]; then
		continue;
	fi
	cp $f ${newname}
	sed -i "s/${1}/${2}/g" ${newname}
done

