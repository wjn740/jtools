#!/bin/sh

set -x
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
	;;
	lmbench_bench)
	${ROOT_DIR}/lmbench_bench.sh lmbench_bench
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
	echo ${testsuite}
	exit 1
	;;
	esac
	popd
	popd
done
popd
