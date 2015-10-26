#!/bin/bash

testcase_namelist="bnnie++_async_btrfs
bonnie++_async_ext4
bonnie++_async_xfs
bonnie++_fsync_btrfs
bonnie++_fsync_ext4
bonnie++_fsync_xfs
dbench4_async_btrfs
dbench4_async_ext4
dbench4_async_xfs
dbench4_fsync_btrfs
dbench4_fsync_ext4
dbench4_fsync_xfs
kernbench
libmicro-bench
lmbench
netperf-peer-loop
netperf-peer-loop6
pgbench_small_ro_btrfs
pgbench_small_ro_ext3
pgbench_small_ro_ext4
pgbench_small_ro_xfs
pgbench_small_rw_btrfs
pgbench_small_rw_ext3
pgbench_small_rw_ext4
pgbench_small_rw_xfs
qa_iozone_doublemem_btrfs
qa_iozone_doublemem_ext4
qa_iozone_doublemem_xfs
qa_siege_performance
qa_tiobench_async_btrfs
qa_tiobench_async_ext4
qa_tiobench_async_xfs
reaim_alltests
reaim_disk_btrfs
reaim_disk_ext4
reaim_disk_xfs
sysbench-sys
sysbench_oltp_btrfs
sysbench_oltp_ext3
sysbench_oltp_ext4
sysbench_oltp_xfs
"
dentrylist=`ls`
for tc_name in ${testcase_namelist}
do
    FOUND_FLAG=0
    for d_item in ${dentrylist}
    do
        if [ ${tc_name} == ${d_item} ]; then
            FOUND_FLAG=1
            break
        fi
    done
    if [ ${FOUND_FLAG} -ne 1 ]; then
        echo "${tc_name} not found"
    fi
done
