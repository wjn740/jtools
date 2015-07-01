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

	#implenment comparing algorithm
	pushd ${NEW_RESULTES}
	#calucate average of all
	pwd
	new_value=`cat reaim-ioperf | awk '{a+=$1}END{print a/NR}'`
	popd
	pushd ${OLD_RESULTES}
	#calucate average of all
	old_value=`cat reaim-alltests | awk '{a+=$1}END{print a/NR}'`
	popd
	c=$(echo "($old_value/$new_value)*100" | bc -l)

	printf "%.2f%%\n" $c >> ${COMPARING_RESULTES}/${filename}
	echo "===============end================"
done
