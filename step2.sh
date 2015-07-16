#!/bin/sh

. ./step1.sh > /dev/null

NEW_DIR=new
OLD_DIR=old

pushd ${HANDLER_DIR}
for testsuite in `cat ${HANDLER_DIR}/.list`
do
	pushd ${testsuite}
	if [ $? -ne 0 ]; then
		echo ${testsuite} 
		exit 348
	fi
	mkdir -pv ${NEW_DIR} ${OLD_DIR}
	pushd ${NEW_DIR}
	case $testsuite in
	pgbench_small_ext3)
	${ROOT_DIR}/pgbench_disp.sh ${testsuite}
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/pgbench_fetch_old_result.sh ${testsuite} ${OLD_LOGS_DIR}
	else
		echo "${testsuite} testing fail"
		exit 1
	fi
	${ROOT_DIR}/pgbench_data_comparing.sh ${NEW_DIR}
	;;
	pgbench_small_xfs)
	${ROOT_DIR}/pgbench_disp.sh ${testsuite}
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/pgbench_fetch_old_result.sh ${testsuite} ${OLD_LOGS_DIR}
	else
		echo "${testsuite} testing fail"
		exit 1
	fi
	${ROOT_DIR}/pgbench_data_comparing.sh ${NEW_DIR}
	;;
	bonniepp_ext3)
	${ROOT_DIR}/bonniepp_disp.sh ${testsuite}
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/bonniepp_fetch_old_result.sh ${testsuite} ${OLD_LOGS_DIR}
	else
		echo "${testsuite} testing fail"
		exit 1
	fi
	${ROOT_DIR}/bonniepp_data_comparing.sh ${NEW_DIR}
	;;
	bonniepp_fsync_ext3)
	${ROOT_DIR}/bonniepp_disp.sh ${testsuite}
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/bonniepp_fetch_old_result.sh ${testsuite} ${OLD_LOGS_DIR}
	else
		echo "${testsuite} testing fail"
		exit 1
	fi
	${ROOT_DIR}/bonniepp_data_comparing.sh ${NEW_DIR}
	;;
	bonniepp_xfs)
	${ROOT_DIR}/bonniepp_disp.sh ${testsuite}
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/bonniepp_fetch_old_result.sh ${testsuite} ${OLD_LOGS_DIR}
	else
		echo "${testsuite} testing fail"
		exit 1
	fi
	${ROOT_DIR}/bonniepp_data_comparing.sh ${NEW_DIR}
	;;
	bonniepp_fsync_xfs)
	${ROOT_DIR}/bonniepp_disp.sh ${testsuite}
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/bonniepp_fetch_old_result.sh ${testsuite} ${OLD_LOGS_DIR}
	else
		echo "${testsuite} testing fail"
		exit 1
	fi
	${ROOT_DIR}/bonniepp_data_comparing.sh ${NEW_DIR}
	;;
	dbench4_ext3)
	${ROOT_DIR}/dbench_disp.sh dbench4_ext3
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/dbench_fetch_old_result.sh ${OLD_DIR} dbench4_ext3
	else
		echo "dbench4_ext3 testing fail"
		exit 1
	fi
	${ROOT_DIR}/dbench_data_comparing.sh ${NEW_DIR}
	;;
	dbench4_fsync_ext3)
	${ROOT_DIR}/dbench_disp.sh dbench4_fsync_ext3
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/dbench_fetch_old_result.sh ${OLD_DIR} dbench4_fsync_ext3
	else
		echo "dbench4_fsync_ext3 testing fail"
		exit 1
	fi
	${ROOT_DIR}/dbench_data_comparing.sh ${NEW_DIR}
	;;
	dbench4_fsync_xfs)
	${ROOT_DIR}/dbench_disp.sh dbench4_fsync_xfs
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/dbench_fetch_old_result.sh ${OLD_DIR} dbench4_fsync_xfs
	else
		echo "dbench4_fsync_xfs testing fail"
		exit 1
	fi
	${ROOT_DIR}/dbench_data_comparing.sh ${NEW_DIR}
	;;
	dbench4_xfs)
	${ROOT_DIR}/dbench_disp.sh dbench4_xfs
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/dbench_fetch_old_result.sh ${OLD_DIR} dbench4_xfs
	else
		echo "dbench4_xfs testing fail"
		exit 1
	fi
	${ROOT_DIR}/dbench_data_comparing.sh ${NEW_DIR}
	;;
	tiobench_basic_ext3)
	${ROOT_DIR}/tiobench_disp.sh tiobench_basic_ext3
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/tiobench_fetch_old_result.sh $testsuite ${OLD_LOGS_DIR}
	else
		echo "tiobench_basic_ext3 testing fail"
		exit 1
	fi
	${ROOT_DIR}/tiobench_data_comparing.sh ${NEW_DIR}
	;;
	tiobench_basic_xfs)
	${ROOT_DIR}/tiobench_disp.sh tiobench_basic_xfs
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/tiobench_fetch_old_result.sh ${testsuite} ${OLD_LOGS_DIR}
	else
		echo "tiobench_basic_xfs testing fail"
		exit 1
	fi
	${ROOT_DIR}/tiobench_data_comparing.sh ${NEW_DIR}
	;;
	iozone_bigmem_basic_ext3)
	${ROOT_DIR}/iozone_disp.sh iozone_bigmem_basic_ext3
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/iozone_fetch_old_result.sh ${NEW_DIR}
	else
		echo "iozone_bigmem_basic_ext3 testing fail"
		exit 1
	fi
	${ROOT_DIR}/iozone_data_comparing.sh ${NEW_DIR}
	;;
	iozone_bigmem_basic_xfs)
	${ROOT_DIR}/iozone_disp.sh iozone_bigmem_basic_xfs
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/iozone_fetch_old_result.sh ${NEW_DIR}
	else
		echo "iozone_bigmem_basic_xfs testing fail"
		exit 1
	fi
	${ROOT_DIR}/iozone_data_comparing.sh ${NEW_DIR}
	;;
	kernbench)
	${ROOT_DIR}/kernbench_disp.sh kernbench
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/kernbench_fetch_old_result.sh ${NEW_DIR}
	else
		echo "kernbench testing fail"
		exit 1
	fi
	${ROOT_DIR}/kernbench_data_comparing.sh ${NEW_DIR}
	;;
	libmicro_bench)
	${ROOT_DIR}/libmicro_bench.sh libmicro_bench
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/libmicro_bench_fetch_old_result.sh ${NEW_DIR}
	else
		echo "libmicro_bench testing fail"
		exit 1
	fi
	${ROOT_DIR}/libmicro_bench_data_comparing.sh ${NEW_DIR}
	;;
	lmbench_bench)
	${ROOT_DIR}/lmbench_bench.sh lmbench_bench
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/lmbench_fetch_old_result.sh ${NEW_DIR}
	else
		echo "lmbench testing fail"
		exit 1
	fi
	${ROOT_DIR}/lmbench_data_comparing.sh ${NEW_DIR}
	;;
	netperf_loop4)
	${ROOT_DIR}/netperf.sh netperf_loop4
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/netperf_fetch_old_result.sh ${NEW_DIR}
	else
		echo "netperf.sh testing fail"
		exit 1
	fi
	${ROOT_DIR}/netperf_data_comparing.sh ${NEW_DIR}
	;;
	netperf_loop6)
	${ROOT_DIR}/netperf.sh netperf_loop6
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/netperf_fetch_old_result.sh ${NEW_DIR}
	else
		echo "netperf.sh testing fail"
		exit 1
	fi
	${ROOT_DIR}/netperf_data_comparing.sh ${NEW_DIR}
	;;
	reaim_ioperf_ext3)
	${ROOT_DIR}/reaim_ioperf_disp.sh reaim_ioperf_ext3
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/reaim_ioperf_fetch_old_result.sh ${NEW_DIR}
	else
		echo "reaim_ioperf_disp.sh testing fail"
		exit 1
	fi
	${ROOT_DIR}/reaim_ioperf_comparing.sh ${NEW_DIR}
	;;
	reaim_ioperf_xfs)
	${ROOT_DIR}/reaim_ioperf_disp.sh reaim_ioperf_xfs
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/reaim_ioperf_fetch_old_result.sh ${NEW_DIR}
	else
		echo "iozone_bigmem_basic_xfs testing fail"
		exit 1
	fi
	${ROOT_DIR}/reaim_ioperf_comparing.sh ${NEW_DIR}
	;;
	siege)
	${ROOT_DIR}/siege.sh siege
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/siege_fetch_old_result.sh ${NEW_DIR}
	else
		echo "siege testing fail"
		exit 1
	fi
	${ROOT_DIR}/siege_data_comparing.sh ${NEW_DIR}
	;;
	sysbench_oltp_ext3)
	${ROOT_DIR}/sysbench.sh sysbench_oltp_ext3
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/sysbench_fetch_old_result.sh ${NEW_DIR}
	else
		echo "sysbench testing fail"
		exit 1
	fi
	${ROOT_DIR}/sysbench_data_comparing.sh ${NEW_DIR}
	;;
	sysbench_oltp_xfs)
	${ROOT_DIR}/sysbench.sh sysbench_oltp_xfs
	if [ $? -eq 0 ]; then
		${ROOT_DIR}/sysbench_fetch_old_result.sh ${NEW_DIR}
	else
		echo "sysbench testing fail"
		exit 1
	fi
	${ROOT_DIR}/sysbench_data_comparing.sh ${NEW_DIR}
	;;
	*)
	echo 'Please review code.'
	echo 'Maybe some new testsuite log package be download to logs_bz2'
	echo ${testsuite}
	exit 1
	;;
	esac
	popd
	popd
done
popd
