#!/bin/bash

#$1:hostname
#$2:arch

SETUP_DIR=`dirname $0`
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
validate_filter()
{
    grep "[0-9].* fail [0-9].* succeed [0-9] count" | awk '{if ($1 > 0) exit 1 ;else if ($3 == 0) exit 1;exit 0;}'
}
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
    grep -v "^#" | grep -v "^ " | grep -v "^Running" | grep -v "fail .* succeed .* count .* internal_error .* skipped" | grep -v ".*:.*: on .* after .*" | grep "^[a-z]" | awk '{print $4}'
}
lmbench_filter()
{
    grep -A 7 '^Context switching'| sed -n 6p| awk '{print $4 $5}'| tr '|' " "
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
    awk 'BEGIN{i=0;j=0;x=0;y=0}/Transaction rate:/{i+=$3;x++} /Throughput:/{j+=$2;y++}END{printf "%f %f\n",i/x,j/y}'
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
    awk '{printf "%-10s\t %-10s\t %+0.5f\t%s,%s\t%s,%s\n",$1,$2,$1/$2*100-100,$4,$5,$6,$7}'
}
speed_formula()
{
    # please explain for dummies like Harald what this AWK formatting is doing ;-)
    awk '{printf "%-10s\t %-10s\t %+0.5f\t%s,%s\t%s,%s\n",$1,$2,$2/$1*100-100,$4,$5,$6,$7}'

}
iozone_formula()
{
    awk '{printf "%s/%s/%-15s\t %-10s\t %-10s\t %+0.5f\t%s,%s\t%s,%s\n",$1,$2,$3,$4,$5,$5/$4*100-100,$4,$5,$6,$7}'
    #speed_formula
}
kernbench_formula()
{
    time_formula
}
libmicro_bench_formula()
{
    awk 'BEGIN{i=0}{if ($2/$3*100-100 < -10) {printf "%15s \t%10s %10s %+12.5f\t%s,%s\t%s,%s **\n",$1,$2,$3,$2/$3*100-100,$4,$5,$6,$7;i+=1} else {printf "%15s \t%10s %10s %+12.5f\t%s,%s\t%s,%s\n",$1,$2,$3,$2/$3*100-100,$4,$5,$6,$7}}END{printf "Failed %d, Total %d, Ratio %0.5f%",i,NR,i/NR*100}'
    #time_formula
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
    #speed_formula
    awk '{printf "%20s\t%-10s\t %-10s\t %+0.5f  %s,%s  %s,%s\n",$1,$2,$3,$3/$2*100-100,$4,$5,$6,$7}'
}
sysbench_formula()
{
    #time_formula
    awk '{printf "%-10s\t%-15s\t %-10s\t %+0.5f\t%s,%s\t%s,%s\n",$1,$2,$3,$2/$3*100-100,$4,$5,$6,$7}'
}
dbench_formula()
{
    awk '{printf "%s %15s %10s\t %+0.5f\t%s,%s\t%s,%s\n",$1,$2,$3,$3/$2*100-100,$4,$5,$6,$7}'
    #speed_formula
}
pgbench_formula()
{
    awk '{printf "%s %s %s\t %12s  %12s\t %+0.5f\t%s,%s\t%s,%s\n",$1,$2,$3,$4,$5,$5/$4*100-100,$4,$5,$6,$7}'
    #speed_formula
}
tiobench_formula()
{
    awk '{printf "%-35s\t%10s%10s  %+0.5f\t%s,%s\t%s,%s\n",$1,$2,$3,$3/$2*100-100,$4,$5,$6,$7}'
    #time_formula
}
bonniepp_formula()
{
    awk '{printf "%-20s\t %-10s\t %-10s\t %+0.5f\t%s,%s\t%s,%s\n",$1,$2,$3,$3/$2*100-100,$4,$5,$6,$7}'
    #speed_formula
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

validate_testcase ()
{
    #$1:casename
    if ! [ -d "$1" ]; then
        return
    fi

    pushd $1

    delete=0
    for x in `ls`
    do
        pushd $x
        for y in `ls`
        do
            case $casename in
                bonnie++*)
                    if ! cat $y | validate_filter ;then
                        rm $y
                    fi
                    ;;
                dbench4*)
                    if ! cat $y | validate_filter ;then
                        rm $y
                    fi
                    ;;
                lmbench*)
                    if ! cat $y | validate_filter ;then
                        rm $y
                    fi
                    ;;
                netperf*)
                    case $y in
                        *udp6)
                            if ! cat $y | validate_filter ;then
                                rm $y
                            fi
                            ;;
                        *udp)
                            if ! cat $y | validate_filter ;then
                                rm $y
                            fi
                            ;;
                        *tcp6)
                            if ! cat $y | validate_filter ;then
                                rm $y
                            fi
                            ;;
                        *tcp)
                            if ! cat $y | validate_filter ;then
                                rm $y
                            fi
                            ;;
                    esac
                    ;;
                pgbench*)
                    if ! cat $y | validate_filter ;then
                        rm $y
                    fi
                    ;;
                qa_iozone*)
                    if ! cat $y | validate_filter ;then
                        rm $y
                    fi
                    ;;
                qa_tiobench*)
                    if ! cat $y | validate_filter ;then
                        rm $y
                    fi
                    ;;
                reaim_disk_*)
                    if ! cat $y | validate_filter ;then
                        rm $y
                    fi
                    ;;
                reaim_alltest*)
                    if ! cat $y | validate_filter ;then
                        rm $y
                    fi
                    ;;
                sysbench_oltp*)
                    if ! cat $y | validate_filter ;then
                        rm $y
                    fi
                    ;;
                sysbench-sys)
                    if ! cat $y | validate_filter ;then
                        rm $y
                    fi
                    ;;
                libmicro*)
                    if ! cat $y | validate_filter ;then
                        rm $y
                    fi
                    ;;
                qa_siege_performance*)
                    if ! cat $y | validate_filter ;then
                        rm $y
                    fi
                    ;;
                kernbench*)
                    if ! cat $y | validate_filter ;then
                        rm $y
                    fi
                    ;;
                *)
                    echo -n "There are some testcase need filters: " >&2
                    rm $y
                    echo "${casename}" >&2
                    ;;
            esac
        done
        popd
        find ./${x} -type d -empty -exec rmdir {} \;
    done
    popd
    find ./${1} -type d -empty -exec rmdir {} \;
}
handle_testcase()
{
    #$1:casename
    logdir_list=`ls`                                             
    if [ -z "${logdir_list}" ]; then
        return
    fi
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
                        *udp6)
                            for i in $(cat ${y} | netperf_udp_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                            echo $j > ../${DATA_GROUP}/${y}/.lines
                            ;;
                        *tcp)
                            for i in $(cat ${y} | netperf_tcp_filter);do echo $i >> ../${DATA_GROUP}/${y}/${y}.${x}; echo $i >> ../${DATA_GROUP}/${y}/line${j};((j++));done
                            echo $j > ../${DATA_GROUP}/${y}/.lines
                            ;;
                        *tcp6)
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
                echo `cat line$i | awk '{a+=$1}END{printf("%.4f\n",a/NR)}'` >> ../../${RESULT_DATA}/${dir}
                echo `cat line$i | awk '{sum+=$1; array[NR]=$1} END {for(x=1;x<=NR;x++){sumsq+=((array[x]-(sum/NR))**2);}print sqrt(sumsq/NR)}'` >> ../../${RESULT_DATA}/${dir}_stddev
            fi
        done
        paste ../../${RESULT_DATA}/${dir} ../../${RESULT_DATA}/${dir}_stddev | awk '{printf "%s\n",$2/$1*100}' > ../../${RESULT_DATA}/${dir}_cv
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
                    validate_testcase ${casename}
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
                        if echo $filename | grep "_stddev$" ;then
                            continue
                        fi
                        if echo $filename | grep "_cv$" ;then
                            continue
                        fi
                        mkdir -pv ${COMARING_RESULT}
                        touch ${COMARING_RESULT}/${filename}
                        echo "${casename} => ${filename}" > ${COMARING_RESULT}/${filename}
                        #create comparing result file
                        case $casename in
                            bonnie++*)
                                echo "                         ${product[0]}     ${product[1]}     ratio       stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ${SETUP_DIR}/bonnie++_title_column ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv| bonniepp_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            dbench4*)
                                echo "Throughput               ${product[0]}     ${product[1]}     ratio        stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ${SETUP_DIR}/dbench4_title_column ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv| dbench_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            lmbench*)
                                echo "                         ${product[0]}     ${product[1]}     ratio       stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename}  ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv| lmbench_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            *udp6)
                                echo "                         ${product[0]}     ${product[1]}     ratio       stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename}  ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv| netperf_udp_formula>> ${COMARING_RESULT}/${filename}
                                        ;;
                            *udp)
                                echo "                         ${product[0]}     ${product[1]}     ratio       stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename}  ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv| netperf_udp_formula>> ${COMARING_RESULT}/${filename}
                                        ;;
                            *tcp6)
                                echo "                         ${product[0]}     ${product[1]}     ratio       stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv | netperf_tcp_formula>> ${COMARING_RESULT}/${filename}
                                        ;;
                            *tcp)
                                echo "                         ${product[0]}     ${product[1]}     ratio       stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename}  ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv| netperf_tcp_formula>> ${COMARING_RESULT}/${filename}
                                        ;;
                            pgbench*)
                                echo "tps                            ${product[0]}     ${product[1]}     ratio       stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ${SETUP_DIR}/pgbench_title_column ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv | pgbench_formula >> ${COMARING_RESULT}/${filename}
                                ;;
                            qa_iozone*)
                                echo "                                 ${product[0]}     ${product[1]}     ratio       stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ${SETUP_DIR}/iozone_title_column ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv | iozone_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            qa_tiobench*)
                                echo "                                           ${product[0]}     ${product[1]}     ratio       stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ${SETUP_DIR}/tiobench_title_column ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv | tiobench_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            reaim_disk_*)
                                echo "                         ${product[0]}     ${product[1]}     ratio       stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv | reaim_ioperf_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            reaim_alltest*)
                                echo "                         ${product[0]}     ${product[1]}     ratio       stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv | reaim_ioperf_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            sysbench_oltp*)
                                echo "                         ${product[0]}     ${product[1]}     ratio       stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ~/sysbench-oltp_column ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv | sysbench_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            sysbench-sys)
                                echo "                         ${product[0]}     ${product[1]}     ratio       stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv | sysbench_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            libmicro*)
                                echo "                         ${product[0]}     ${product[1]}     ratio       stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ${SETUP_DIR}/libmicro_bench_column ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv | libmicro_bench_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            qa_siege_performance*)
                                echo "                         ${product[0]}     ${product[1]}     ratio       stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ${SETUP_DIR}/siege_column ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv | siege_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            kernbench*)
                                echo "                         ${product[0]}     ${product[1]}     ratio       stddev(SP0,SP1)      C.V.(SP0,SP1)" >> ${COMARING_RESULT}/${filename}
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv | kernbench_formula>> ${COMARING_RESULT}/${filename}
                                ;;
                            *)
                                paste ${product[0]}/${RESULT_DATA}/${filename} ${product[1]}/${RESULT_DATA}/${filename} ${product[0]}/${RESULT_DATA}/${filename}_stddev ${product[1]}/${RESULT_DATA}/${filename}_stddev ${product[0]}/${RESULT_DATA}/${filename}_cv ${product[1]}/${RESULT_DATA}/${filename}_cv | time_formula >> ${COMARING_RESULT}/${filename}
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
