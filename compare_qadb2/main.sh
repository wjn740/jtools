#!/bin/bash

#$1:hostname
#$2:arch

ROOT_DIR=`pwd -P`
FORTMATED_DIR=${ROOT_DIR}/format_dir
COMARING_DIR=${ROOT_DIR}/comparing_dir
DATA_GROUP=".data_group"
RESULT_DATA=".result"
COMARING_RESULT=".compare_result"
DATA_GROUP_LINES=".lines"

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
netperf_tcp_filter()
{
    grep "^ [0-9]*" | awk '{print $5}'
}
netperf_udp_filter()
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

##########################
#Comparison function
#
##########################
time_formula()
{
    awk '{printf "%-10s\t %-10s\t %+0.5f\n",$1,$2,$1/$2*100-100}'
}
speed_formula()
{
    awk '{printf "%-10s\t %-10s\t %+0.5f\n",$1,$2,$2/$1*100-100}'

}
iozone_formula()
{
    speed_formula
}
kernbench_formula()
{
    time_formula
}
libmicro_bench_formula()
{
    time_formula
}
lmbench_formula()
{
    time_formula
}
netperf_udp_formula()
{
    speed_formula
}
netperf_tcp_formula()
{
    speed_formula
}
reaim_ioperf_formula()
{
    speed_formula
}
siege_formula()
{
    speed_formula
}
sysbench_formula()
{
    time_formula
}
dbench_formula()
{
    time_formula
}
pgbench_formula()
{
    speed_formula
}
tiobench_formula()
{
    time_formula
}
bonniepp_formula()
{
    speed_formula
}


#There are three kinds of directory hierarchy:
#DDH:Download Direcroty Hierarchy
#GDH:Data Group Direcroty Hierarchy
#CDH:Comparing Direcroty Hierarchy
setup_fortmat_dir()
{
    #This function will restruct directory hierarchy from
    #product/release/arch/hostname/casename/testcase/(DDH) to 
    #/hostname/arch/product/casename/testcase/ (GDH)
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
                            casename=`echo ${testcase}|awk -F '-' '{for (i=1;i<=NF-6;i++) {printf "%s",$i; if (i<NF-6) printf "%s","-"}}'`
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
                    for i in $(cat ${y} | bonniepp_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                    echo $j > ../${DATA_GROUP}/${y}/.lines
                    ;;
                dbench4*)
                    for i in $(cat ${y} | dbench_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                    echo $j > ../${DATA_GROUP}/${y}/.lines
                    ;;
                lmbench*)
                    for i in $(cat ${y} | lmbench_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                    echo $j > ../${DATA_GROUP}/${y}/.lines
                    ;;
                netperf*)
                    case $y in
                        *udp)
                            for i in $(cat ${y} | netperf_udp_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                            echo $j > ../${DATA_GROUP}/${y}/.lines
                            ;;
                        *tcp)
                            for i in $(cat ${y} | netperf_tcp_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                            echo $j > ../${DATA_GROUP}/${y}/.lines
                            ;;
                    esac
                    ;;
                pgbench*)
                    for i in $(cat ${y} | pgbench_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                    echo $j > ../${DATA_GROUP}/${y}/.lines
                    ;;
                qa_iozone*)
                    for i in $(cat ${y} | iozone_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                    echo $j > ../${DATA_GROUP}/${y}/.lines
                    ;;
                qa_tiobench*)
                    for i in $(cat ${y} | tiobench_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                    echo $j > ../${DATA_GROUP}/${y}/.lines
                    ;;
                reaim_disk_*)
                    for i in $(cat ${y} | reaim_ioperf_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                    echo $j > ../${DATA_GROUP}/${y}/.lines
                    ;;
                reaim_alltest*)
                    for i in $(cat ${y} | reaim_ioperf_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                    echo $j > ../${DATA_GROUP}/${y}/.lines
                    ;;
                sysbench_oltp*)
                    for i in $(cat ${y} | sysbench_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                    echo $j > ../${DATA_GROUP}/${y}/.lines
                    ;;
                sysbench-sys)
                    for i in $(cat ${y} | sysbench_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                    echo $j > ../${DATA_GROUP}/${y}/.lines
                    ;;
                libmicro*)
                    for i in $(cat ${y} | libmicro_bench_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                    echo $j > ../${DATA_GROUP}/${y}/.lines
                    ;;
                qa_siege_performance*)
                    for i in $(cat ${y} | siege_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                    echo $j > ../${DATA_GROUP}/${y}/.lines
                    ;;
                kernbench*)
                    for i in $(cat ${y} | kernbench_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                    echo $j > ../${DATA_GROUP}/${y}/.lines
                    ;;
                *)
                    echo -n "There are some testcase need filters: " >&2
                    echo "${casename}" >&2
            esac


        done
        popd                                                           

    done
    mkdir -pv ${RESULT_DATA}
    pushd ${DATA_GROUP}
    echo `pwd`
    for dir in `ls`
    do
        pushd $dir
        j=`cat ${DATA_GROUP_LINES}`
        for i in `seq 1 $(($j - 1))`
        do
            if [ -f line$i ]; then
                echo `cat line$i | awk '{a+=$1}END{printf("%.2f\n",a/NR)}'` >> ../../${RESULT_DATA}/${casename}
            fi
        done
        popd
    done
    popd


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

comparing_function()
{
    #Create comparing tree
    if [ -d ${FORTMATED_DIR} ]; then
        #enter FORTMATED_DIR
        pushd ${FORTMATED_DIR}
    else
        return
    fi

    #The following code can be Integrated into filling_data_group
    #But That will broken code framework.
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
                    if [ -d ${RESULT_DATA} ]; then
                        mkdir -vp ${COMARING_DIR}/${casename}/${hostname}/${arch}/${product}/
                        cp -a ${RESULT_DATA} ${COMARING_DIR}/${casename}/${hostname}/${arch}/${product}/
                    fi
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

    #comparing each testcase's result
    if [ -d ${COMARING_DIR} ];then
        pushd ${COMARING_DIR}
    else
        return
    fi
    for casename in `ls`
    do
        if [ -d ${casename} ]; then
            pushd ${casename}
        else
            echo `pwd`
            continue
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
                {
                    #product directory
                    # nr=`find . -type f | wc -l`
                    # if [ $nr -eq 2 ]; then
                    #     :
                    # else
                    #     echo "Result not enough to compare." >&2
                    #     popd
                    #     continue
                    # fi

                    for product in `ls`
                    do
                        ret=`find ./${product} -type d -empty`
                        if ! [ -z $ret ]; then
                            echo "some thing wrong, There is a empty result directory."
                            echo "${COMARING_DIR}/${casename}/${hostname}/${arch}/${product}"
                            exit 1;
                        fi
                    done

                    product=(`ls`)
                    for i in `seq 0 $((${#product[@]} - 1))`
                    do
                        [ -d ${product[$i]} ] || { popd; continue; };
                        [ -d ${product[$i]}/${RESULT_DATA} ] || { popd; continue; };
                    done

                    #This begian for comparing
                    for file in `ls ${product[0]}/${RESULT_DATA}/*`
                    do
                        filename=$(basename ${file})
                        if ! [ -f ${product[1]}/${RESULT_DATA}/${filename} ];then
                            continue
                        fi
                        mkdir -pv ${COMARING_RESULT}
                        touch ${COMARING_RESULT}/${filename}
                        echo "${casename}" > ${COMARING_RESULT}/${filename}
                        echo "${product[0]}  ${product[1]}" >> ${COMARING_RESULT}/${filename}
                        case $casename in
                            bonnie++*)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} | bonniepp_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            dbench4*)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} | dbench_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            lmbench*)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} | lmbench_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            *udp)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} | netperf_udp_formula>> ${COMARING_RESULT}/${filename}
                                        ;;
                            *tcp)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} | netperf_tcp_formula>> ${COMARING_RESULT}/${filename}
                                        ;;
                            pgbench*)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} | pgbench_formula >> ${COMARING_RESULT}/${filename}
                                ;;
                            qa_iozone*)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} | iozone_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            qa_tiobench*)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} | tiobench_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            reaim_disk_*)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} | reaim_ioperf_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            reaim_alltest*)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} | reaim_ioperf_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            sysbench_oltp*)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} | sysbench_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            sysbench-sys)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} | sysbench_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            libmicro*)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} | libmicro_bench_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            qa_siege_performance*)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} | siege_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            kernbench*)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} | kernbench_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            *)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} | time_formula >> ${COMARING_RESULT}/${filename}
                        esac
                    done
                }
                popd
            done
            popd
        done
        popd
    done
    #leave comparing directory
    popd
}

if ! [ -d ${FORTMATED_DIR} ]; then
    setup_fortmat_dir
    set -x
    filling_data_group
fi

if ! [ -d ${COMARING_DIR} ]; then
    comparing_function
fi
