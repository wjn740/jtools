#!/bin/bash

#$1:hostname
#$2:arch

ROOT_DIR=`pwd -P`
FORTMATED_DIR=${ROOT_DIR}/format_dir
DATA_GROUP=".data_group"

###################
#
# Testcase filter
#
###################
iozone_filter()
{
    grep -A 6 '^ *KB' |tail -n 6 |  awk '{print $3, $4, $5, $6, $7, $8, $9}'
}
kernbench_filter()
{
    egrep "^Elapsed Time | ^System Time" | awk '{print $3}'
}
libmicro_bench_filter()
{
    grep ^memset | awk '{print $4}'
}
lmbench_filter()
{
    grep -A 7 '^Context switching' |tail -n 3 |  awk '{print $4, $5, $6, $7, $8, $9, $10}'
}
netperf_filter()
{
    egrep '^[0-9]+'| head -n 2 | awk '{if(NR==1)print $6;if(NR==2) print $4;}'
}
reaim_ioperf_filter()
{
    grep "^Max Jobs per Minute " | awk '{print $5}'
}
siege_filter()
{
    egrep "^Transaction rate:|^Throughput:" | awk -F ':' '{print $2}'|awk '{print $1}'
}
sysbench_filter()
{
    grep "total time:.*s" | awk '{print $3}' | awk -F 's' '{print $1}'
}
dbench_filter()
{
    grep "^Throughput [0-9].*ms" | awk '{print $2}'
}
pgbench_filter()
{
    grep "^tps" | awk -F " "  '{print $3}'
}
tiobench_filter()
{
    grep "^[2-4]\.[0-9]*\.[0-9]*-[0-9.]*-[a-z]*" | awk '{print $5}'
}
bonniepp_filter()
{
    grep -A 1 "^Machine" | sed -n 2p | awk '{print $3, $5, $7, $9, $11}'
}


setup_fortmat_dir()
{
    #This function will restruct directory hierarchy from
    #product/release/arch/hostname/casename/testcase/ to 
    #/hostname/arch/product/casename/testcase/
    for product in `ls`
    do
        if [ -d ${product} ]; then
            pushd ${product}
        else
            continue
        fi
        for release in `ls` 
        do
            if [ -d ${release} ]; then
                pushd ${release}
            else
                continue
            fi
            for arch in `ls`
            do
                if [ -d ${arch} ]; then
                    pushd ${arch}
                else
                    continue
                fi
                for hostname in `ls`
                do
                    if [ -d ${hostname} ]; then
                        pushd ${hostname}
                    else
                        continue
                    fi
                    for testcase in `ls`
                    do
                        if [ -d ${testcase} ]; then
                            #get the name of testcase
                            casename=`echo ${testcase}|awk -F '-' '{print $1}'`
                            mkdir -vp ${FORTMATED_DIR}/${hostname}/${arch}/${product}/${casename}
                            cp -va ${testcase} ${FORTMATED_DIR}/${hostname}/${arch}/${product}/${casename}
                        else
                            continue
                        fi
                    done
                    popd
                done
                popd
            done
            popd
        done
        popd
    done
}

handle_testcase()
{
#$1:casename
logdir_list=`ls`                                             
mkdir -pv ${DATA_GROUP}
#x is directory 
for x in ${logdir_list}                                      
do      
    pushd $x                                                       
    #y is logfile
    for y in `ls`
    do
        mkdir -pv ../${DATA_GROUP}/${y}
        touch ../${DATA_GROUP}/${y}/${y}.${x}
        j=1
        #因为我们需要合并新测试数据（求平均，求和） 
        #所以我们需要把数据转化成一行一行的
        case $casename in
            bonnie++*)
            for i in $(cat ${y} | bonniepp_filter);do echo $i >> ${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ${DATA_GROUP}/${y}/line${j};((j++));done
            ;;
            dbench4*)
            for i in $(cat ${y} | dbench_filter);do echo $i >> ${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ${DATA_GROUP}/${y}/line${j};((j++));done
            ;;
            lmbench*)
            for i in $(cat ${y} | lmbench_filter);do echo $i >> ${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ${DATA_GROUP}/${y}/line${j};((j++));done
            ;;
            netperf*)
            for i in $(cat ${y} | netperf_filter);do echo $i >> ${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ${DATA_GROUP}/${y}/line${j};((j++));done
            ;;
            pgbench*)
            for i in $(cat ${y} | pgbench_filter);do echo $i >> ${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ${DATA_GROUP}/${y}/line${j};((j++));done
            ;;
            qa_iozone*)
            for i in $(cat ${y} | iozone_filter);do echo $i >> ${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ${DATA_GROUP}/${y}/line${j};((j++));done
            ;;
            qa_tiobench*)
            for i in $(cat ${y} | tiobench_filter);do echo $i >> ${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ${DATA_GROUP}/${y}/line${j};((j++));done
            ;;
            reaim_disk_*)
            for i in $(cat ${y} | reaim_ioperf_filter);do echo $i >> ${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ${DATA_GROUP}/${y}/line${j};((j++));done
            ;;
            sysbench_oltp*)
            for i in $(cat ${y} | sysbench_filter);do echo $i >> ${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ${DATA_GROUP}/${y}/line${j};((j++));done
            ;;
            libmicro*)
            for i in $(cat ${y} | libmicro_bench_filter);do echo $i >> ${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ${DATA_GROUP}/${y}/line${j};((j++));done
            ;;
            qa_siege_performance*)
            for i in $(cat ${y} | siege_filter);do echo $i >> ${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ${DATA_GROUP}/${y}/line${j};((j++));done
            ;;
            kernbench*)
            for i in $(cat ${y} | kernbench_filter);do echo $i >> ${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ${DATA_GROUP}/${y}/line${j};((j++));done
            ;;
            *)
            echo "There are some testcase need filters:" >&2
            echo "${casename}" >&2
        esac
    done
    popd                                                           
done

}

filling_data_group()
{
    if [ -d ${FORTMATED_DIR} ]; then
        #enter FORTMATED_DIR
        pushd ${FORTMATED_DIR}
    else
        return
    fi
    for hostname in `ls`
    do
        if [ -d ${hostname} ]; then
            pushd ${hostname}
        else
            continue
        fi
        for arch in `ls`
        do
            if [ -d ${arch} ]; then
                pushd ${arch}
            else
                continue
            fi
            for product in `ls`
            do
                if [ -d ${product} ]; then
                    pushd ${product}
                else
                    continue
                fi
                for casename in `ls`
                do
                   if [ -d ${casename} ]; then
                       pushd $casename
                   else
                       continue
                   fi
                   handle_testcase ${casename}
                   popd
                done
                popd
            done
            popd
        done
        popd
    done
    #leave FORTMATED_DIR
    popd
}
setup_fortmat_dir
set -x
#filling_data_group
