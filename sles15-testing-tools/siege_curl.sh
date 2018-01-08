#!/bin/bash
set -eu

if [ -z $1 ];then
	exit
fi
if [ -z $2 ];then
	exit
fi

curl $1 | grep -v "^#"| grep -v "^Running" | grep -v "^ " | grep -v "^!" | egrep "(Transaction rate:|Throughput:)">a.log
curl $2 | grep -v "^#"| grep -v "^Running" | grep -v "^ " | grep -v "^!" | egrep "(Transaction rate:|Throughput:)">b.log

paste [ab].log | awk 'BEGIN{i=0;j=0;
															Transaction_A=0;Transaction_B=0;Transaction_A_sum=0;Transaction_B_sum=0;
															Throughput_A=0;Throughput_B=0;Throughput_A_sum=0;Throughput_B_sum=0;}
											{if ($1 == "Transaction") {Transaction_A_sum+=$3;Transaction_B_sum+=$7;i++;}; 
												if ($1 == "Throughput:") {Throughput_A_sum+=$2;Throughput_B_sum+=$5;j++;};
												}END{print "Transaction", "trans/sec", "\t", Transaction_A_sum/i,  "\t", Transaction_B_sum/i, "\t", (1-((Transaction_A_sum/i)/(Transaction_B_sum/i)))*100, "%";
												print "Throughput", "MB/sec","\t",Throughput_A_sum/j, "\t", Throughput_B_sum/j, "\t", (1-((Throughput_A_sum/i)/(Throughput_B_sum/i)))*100, "%";
												}'
