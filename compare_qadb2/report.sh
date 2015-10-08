#!/bin/bash
for arch in `ls`; 
do 
    pushd $arch 2>&1 >/dev/null; 
    echo ============================
    echo $arch
    echo ============================
    echo
    for host in `ls`; 
    do 
        
        pushd $host 2>&1 >/dev/null; 
        echo \* $host :
        echo -----------------------------
        ls -t | rev | uniq -s 20 -c | rev; 
        echo
        popd 2>&1 >/dev/null; 
    done;     
    popd 2>&1 >/dev/null;
done
