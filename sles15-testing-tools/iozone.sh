#!/bin/bash
set -eu
head -n -2 $1 >./tmp
cat ./tmp | awk '/report"/,/^$/{print $0}' | awk '/"[A-Z][a-z].*"/ {T=$0;next;} /^ .*/{for(a=1;a<=NF;a++){ARRAY[a]=$a;};next;} {a=NF;for(a=2;a<=NF;a++){print T,$1,ARRAY[a-1],$a}}'
rm ./tmp
