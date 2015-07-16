#!/bin/bash

set -x

##########################################
#Name:pgbench_extract
#Description:
#  This Function will extract pgdench log tarball 
#to current. 
#Parameter:
#$1:[NEW|OLD]_LOGS_DIR
#$2:testcase's name
##########################################

pgbench_extract()
{
    
    tarball_list=$(ls ${1}/${2}-*.tar.bz2)
    if [ -z ${tarball_list} ]; then
        echo "[$0]:LOG_DIR not exist." >&2
        exit 1
    fi

    for tarball in ${tarball_list}
    do
        #extract log tarball no dependence on testsutie
        mkdir t
        pushd t
        tar xf ${tarball}
        log_dir=`ls -tr | tail -n 1`
        rm -rf `ls | grep -v "^${log_dir}$"`
        mv ${log_dir} ../
        popd
        rm -rf t
        #remove noused files dependence on testsutie
        pushd ${log_dir}
        rm -rf `ls | egrep -v "^simple-pgbench-[a-z].*-r[wo]$"`
        popd
    done
}
##########################################
#Name:bonniepp_extract
#Description:
#  This Function will extract dbench log tarball 
#to current. 
#Parameter:
#$1:NEW_LOGS_DIR
#$2:testcase's name
##########################################

bonniepp_extract()
{
    tarball_list=$(ls ${1}/${2}-*.tar.bz2)

    for tarball in ${tarball_list}
    do
        #extract log tarball no dependence on testsutie
        mkdir t
        pushd t
        tar xf ${tarball}
        log_dir=`ls -tr | tail -n 1`
        rm -rf `ls | grep -v "^${log_dir}$"`
        mv ${log_dir} ../
        popd
        rm -rf t
        #remove noused files dependence on testsutie
        pushd ${log_dir}
        rm -rf `ls | egrep -v "^bonnie\+\+-async$|^bonnie\+\+-fsync$"`
        popd
    done
}
##########################################
#Name:dbench_extract
#Description:
#  This Function will extract dbench log tarball 
#to current. 
#Parameter:
#$1:NEW_LOGS_DIR
#$2:testcase's name
##########################################

dbench_extract()
{
    tarball_list=$(ls ${1}/${2}-*.tar.bz2)

    for tarball in ${tarball_list}
    do
        #extract log tarball no dependence on testsutie
        mkdir t
        pushd t
        tar xf ${tarball}
        log_dir=`ls -tr | tail -n 1`
        rm -rf `ls | grep -v "^${log_dir}$"`
        mv ${log_dir} ../
        popd
        rm -rf t
        #remove noused files dependence on testsutie
        pushd ${log_dir}
        rm -rf `ls | egrep -v "^dbench-default$|^dbench-fsyncIO$"`
        popd
    done
}

##########################################
#Name:tiobench_extract
#Description:
#  This Function will extract tiobench log tarball 
#to current dir. 
#Parameter:
#$1:NEW_LOGS_DIR
#$2:testcase's name
##########################################

tiobench_extract()
{
    tarball_list=$(ls ${1}/${2}-*.tar.bz2)

    for tarball in ${tarball_list}
    do
        #extract log tarball no dependence on testsutie
        mkdir t
        pushd t
        tar xf ${tarball}
        log_dir=`ls -tr | tail -n 1`
        rm -rf `ls | grep -v "^${log_dir}$"`
        mv ${log_dir} ../
        popd
        rm -rf t
        #remove noused files dependence on testsutie
        pushd ${log_dir}
	    rm -rf `ls | grep -v "^tiobench-"`
        popd
    done
}
