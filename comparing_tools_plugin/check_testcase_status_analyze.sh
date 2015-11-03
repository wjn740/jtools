#!/bin/bash



# Reset
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Underline
UBlack='\e[4;30m'       # Black
URed='\e[4;31m'         # Red
UGreen='\e[4;32m'       # Green
UYellow='\e[4;33m'      # Yellow
UBlue='\e[4;34m'        # Blue
UPurple='\e[4;35m'      # Purple
UCyan='\e[4;36m'        # Cyan
UWhite='\e[4;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

# High Intensity
IBlack='\e[0;90m'       # Black
IRed='\e[0;91m'         # Red
IGreen='\e[0;92m'       # Green
IYellow='\e[0;93m'      # Yellow
IBlue='\e[0;94m'        # Blue
IPurple='\e[0;95m'      # Purple
ICyan='\e[0;96m'        # Cyan
IWhite='\e[0;97m'       # White

# Bold High Intensity
BIBlack='\e[1;90m'      # Black
BIRed='\e[1;91m'        # Red
BIGreen='\e[1;92m'      # Green
BIYellow='\e[1;93m'     # Yellow
BIBlue='\e[1;94m'       # Blue
BIPurple='\e[1;95m'     # Purple
BICyan='\e[1;96m'       # Cyan
BIWhite='\e[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\e[0;100m'   # Black
On_IRed='\e[0;101m'     # Red
On_IGreen='\e[0;102m'   # Green
On_IYellow='\e[0;103m'  # Yellow
On_IBlue='\e[0;104m'    # Blue
On_IPurple='\e[0;105m'  # Purple
On_ICyan='\e[0;106m'    # Cyan
On_IWhite='\e[0;107m'   # White

############################################################################################################

bonnie++-filter ()
{
    awk 'BEGIN{failed=0}/mean/{if ($6 < -10) printf"%s**\n" $0;failed=1}END{if (failed==1) {exit 1}}'
}
tiobench-filter ()
{
    awk 'BEGIN{failed=0;sum_ratio=0;n=0;}/mean/{sum_ratio=sum_ratio+$8;array[n]=$8;n++;if ($8 < -10) printf "%s **\n",$0;failed=1;}END{for(x=1;x<=n;x++){sumsq+=((array[x]-(sum/n))**2);}printf "**Stddev:%f**\n",sqrt(sumsq/n);printf "**Amean:%f**\n",sum_ratio/n; printf "**C.V:%f**\n",100*(sqrt(sumsq/n)/(sum_ratio/n));if (failed==1) {exit 1}}'
}
sysbench_sys-filter ()
{
    awk 'BEGIN{failed=0}/mean/{if ($6 > 10) printf "%s **\n",$0;failed=1}END{if (failed==1) {exit 1}}'
}
sysbench_oltp-filter ()
{
    awk 'BEGIN{failed=0}/mean/{if ($6 > 10) printf "%s **\n",$0;failed=1}END{if (failed==1) {exit 1}}'
}
siege-filter ()
{
    awk 'BEGIN{failed=0}/mean/{if ($4 < -10) printf "%s **\n",$0;failed=1}END{if (failed==1) {exit 1}}'
}
reaim-filter ()
{
    awk 'BEGIN{failed=0}/mean/{if ($4 < -10) printf "%s **\n",$0;failed=1}END{if (failed==1) {exit 1}}'
}
pgbench-rw-filter ()
{
    awk 'BEGIN{failed=0}/mean/{if ($6 < -10) printf "%s **\n",$0;failed=1}END{if (failed==1) {exit 1}}'
}

pgbench-filter ()
{
    awk 'BEGIN{failed=0}/mean/{if ($5 < -10) printf "%s **\n",$0;failed=1}END{if (failed==1) {exit 1}}'
}

netperf-filter ()
{
    awk 'BEGIN{failed=0}/mean/{if ($5 < -10) printf "%s **\n",$0;failed=1}END{if (failed==1) {exit 1}}'
}

lmbench-filter ()
{
    awk 'BEGIN{failed=0}/mean/{if ($4 > 10) printf "%s **\n",$0;failed=1}END{if (failed==1) {exit 1}}'
}

kernbench-filter ()
{
    awk 'BEGIN{failed=0}/mean/{if ($5 < -10) printf "%s **\n",$0;failed=1}END{if (failed==1) {exit 1}}'
}

iozone-filter ()
{
    awk 'BEGIN{failed=0}/mean/{if ($6 < -10) printf "%s **\n",$0;failed=1}END{if (failed==1) {exit 1}}'
}

dbench4-filter ()
{
    awk 'BEGIN{failed=0}/mean/{if ($4 < -10) printf "%s **\n",$0;failed=1}END{if (failed==1) {exit 1}}'
}
bonnie++-filter ()
{
    awk 'BEGIN{failed=0}/mean/{if ($5 < -10) printf "%s **\n",$0;failed=1}END{if (failed==1) {exit 1}}'
}
for d in `ls`
do
    _FAILED=0
    echo "Testcase $d"
    #enter a testcase
    pushd $d 2>&1 >/dev/null
    for arch in `ls` 
    do
        if [ "${arch}x" == "x86_64x" ]; then
            continue;
        fi
        echo "Arch on $arch"
        #enter a arch
        pushd $arch 2>&1 >/dev/null
        for m in `ls`
        do
            #enter certain machine's log
            pushd $m 2>&1 >/dev/null
            for f in `ls`
            do
                text=

                case $d in
                    qa_siege*)
                        text=`cat $f | siege-filter`
                        ;;
                    bonnie++*)
                        text=`cat $f | bonnie++-filter`
                        ;;
                    dbench4*)
                        text=`cat $f | dbench4-filter`
                        ;;
                    kernbench)
                        text=`cat $f | kernbench-filter`
                        ;;
                    lmbench)
                        text=`cat $f | lmbench-filter`
                        ;;
                    netperf-peer*)
                        text=`cat $f | netperf-filter`
                        ;;
                    pgbench_small_rw*)
                        text=`cat $f | pgbench-rw-filter`
                        ;;
                    pgbench_small_ro*)
                        text=`cat $f | pgbench-filter`
                        ;;
                    qa_iozone*)
                        text=`cat $f | iozone-filter`
                        ;;
                    qa_tiobench*)
                        text=`cat $f | tiobench-filter`
                        ;;
                    reaim*)
                        text=`cat $f | reaim-filter`
                        ;;
                    sysbench_oltp*)
                        text=`cat $f | sysbench_oltp-filter`
                        ;;
                    sysbench*)
                        text=`cat $f | sysbench_sys-filter`
                        ;;
                esac
                if [ -n "${text}" ]; then
                    _FAILED=1
                    #echo -e "The machine $m is ${Red}FAILED${Color_Off}"
                    echo -e "${text}"
                    echo $m
                else
                    :
                    echo $m
                    #echo -e "The machine $m is ${White}PASSED${Color_Off}"
                fi
            done
            popd 2>&1 >/dev/null
        done
        popd 2>&1 >/dev/null
    done
    popd 2>&1 >/dev/null
    if [ ${_FAILED} -eq 1 ]; then
        echo -e "The test case $d is ${Red}FAILED${Color_Off}"
    else
        echo -e "The test case $d is ${White}PASSED${Color_Off}"
    fi

    echo "========================================================="
done



