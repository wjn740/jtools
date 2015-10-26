#!/bin/bash

root_dir_by_machine=/tmp/comparing_result_by_machine
xen_dir=${root_dir_by_machine}/xen
x86_64_dir=${root_dir_by_machine}/x86_64

rm -rf ${root_dir_by_machine}

mkdir -pv ${root_dir_by_machine}

mkdir -pv ${xen_dir}
mkdir -pv ${x86_64_dir}

for arch in `ls`
do
    #enter arch dir
    pushd $arch

    for t in `ls`
    do
        #enter testcase directory
        pushd $t 
        for m in `ls`
        do
            #machine's name is $m, then it's a directory
            #there is some results file in it(usually only one).
            mkdir -pv ${root_dir_by_machine}
            if [ "${arch}x" == "xenx" ]; then
                mkdir -pv ${xen_dir}
                mkdir -pv ${xen_dir}/${m}/${t}
                cp -a ${m}/* ${xen_dir}/${m}/${t}
            elif [ "${arch}x" == "x86_64x" ]; then
                mkdir -pv ${x86_64_dir}
                mkdir -pv ${x86_64_dir}/${m}/${t}
                cp -a ${m}/* ${x86_64_dir}/${m}/${t}
            fi
        done
        #leave testcase directory
        popd
    done
    #leave arch dir
    popd
done
