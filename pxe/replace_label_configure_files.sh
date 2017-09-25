#!/bin/bash

while read filename
do
	echo ${filename}
	sed -i "s/$1/$2/g" ${filename}
	sed -i "s/$3/$4/g" ${filename}
done < "${10:-/dev/stdin}"
