#!/bin/bash
set -eu

machines=("apac2-ph022.apac.novell.com" "apac2-ph031.apac.novell.com" "ix64ph1054")
archs=("xen0-x86_64")
products=("SLES-12-SP0" "SLES-12-SP1")
versions=("RC3A" "GM")
testcases=("libmicro")

for p in ${products[@]}
do
    for v in ${versions[@]}
    do
        for a in ${archs[@]}
        do
            for m in ${machines[@]}
            do
                for t in ${testcases[@]}
                do
                wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*,messages.syslog,messages.shortlog,rpmlist,hwinfo,kernel,environment,done,timer_state,test_results,process_state,netserver-start,cmdline.txt,installed-pattern.txt,lscpu.txt,lspci-k.txt,lsscsi.txt,lsmod.txt,meminfo.txt,partition-mount.txt,syslog-journalctl.txt,systemctl-list-units.txt,zoneinfo.txt" --accept-regex=${t} http://147.2.207.30/Results/ProductTests/${p}/${v}/${a}/${m}/ &
            done
            done
        done
    done
done
