#!/bin/bash

set -x

NEW_RESULTES=./result
OLD_RESULTES=../old/result

mkdir ../result
COMPARING_RESULTES="${PWD}/../result"

echo "===============start================"
for file in `ls ${NEW_RESULTES}/*`
do
	echo "===============start================"
	filename=$(basename ${file})
	touch ${COMPARING_RESULTES}/${filename}
	arrayNew=($(cat ${file}))
	arrayOld=($(cat ${OLD_RESULTES}/${filename}))	
	for i in $(seq 0 $((${#arrayNew[@]}-1)))
	do
	c=$(echo "(${arrayNew[$i]}/${arrayOld[$i]})*100"|bc -l)
	printf "%.2f%%\n" $c >> ${COMPARING_RESULTES}/${filename}
	done
	echo "===============end================"
done
