#!/bin/bash
set -eu

if [ -z $1 ];then
	exit
fi
if [ -z $2 ];then
	exit
fi

curl $1 | tail -n 3 | head -n 1 >a.log
curl $2 | tail -n 3 | head -n 1  >b.log

#paste [ab].log | awk '{print $1, "\t",$2, "\t", $4, "\t",(1-($4/$2))*100,"%"}'
paste [ab].log 
paste [ab].log | awk '{split($1,arrayA, ",");
											split($2, arrayB, ",");
											printf("%s/%s(%s)\t%d\t%d\t%f%%\n","Sequential_Output", "Per_Chr", "K/sec", arrayA[3], arrayB[3], (1-(arrayB[3]/arrayA[3]))*100);
											printf("%s/%s(%s)\t%d\t%d\t%f%%\n","Sequential_Output", "Block", "K/sec", arrayA[5], arrayB[5], (1-(arrayB[5]/arrayA[5]))*100);
											printf("%s/%s(%s)\t%d\t%d\t%f%%\n","Sequential_Output", "Rewrite", "K/sec", arrayA[7], arrayB[7], (1-(arrayB[7]/arrayA[7]))*100);
											printf("%s/%s(%s)\t%d\t%d\t%f%%\n","Sequential_Input", "Per_Chr", "K/sec", arrayA[9], arrayB[9], (1-(arrayB[9]/arrayA[9]))*100);
											printf("%s/%s(%s)\t%d\t%d\t%f%%\n","Sequential_Input", "Block", "K/sec", arrayA[11], arrayB[11], (1-(arrayB[11]/arrayA[11]))*100);
											printf("%s/%s(%s)\t%d\t%d\t%f%%\n","Random", "Seek", "sec", arrayA[11], arrayB[11], (1-(arrayB[11]/arrayA[11]))*100);
											printf("%s/%s(%s)\t%d\t%d\t%f%%\n","Sequential_Create", "Create", "sec", arrayA[3], arrayB[3], (1-(arrayB[3]/arrayA[3]))*100);
											printf("%s/%s(%s)\t%d\t%d\t%f%%\n","Sequential_Create", "Read", "sec", arrayA[5], arrayB[5], (1-(arrayB[5]/arrayA[5]))*100);
											printf("%s/%s(%s)\t%d\t%d\t%f%%\n","Sequential_Create", "Delete", "sec", arrayA[7], arrayB[7], (1-(arrayB[7]/arrayA[7]))*100);
											printf("%s/%s(%s)\t%d\t%d\t%f%%\n","Random_Create", "Create", "sec", arrayA[3], arrayB[3], (1-(arrayB[3]/arrayA[3]))*100);
											printf("%s/%s(%s)\t%d\t%d\t%f%%\n","Random_Create", "Read", "sec", arrayA[5], arrayB[5], (1-(arrayB[5]/arrayA[5]))*100);
											printf("%s/%s(%s)\t%d\t%d\t%f%%\n","Random_Create", "Delete", "sec", arrayA[7], arrayB[7], (1-(arrayB[7]/arrayA[7]))*100);
										
										}'
