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
	iozone_bigmem_basic_ext3)
	${ROOT_DIR}/iozone_disp.sh iozone_bigmem_basic_ext3
	;;
	iozone_bigmem_basic_xfs)
	${ROOT_DIR}/iozone_disp.sh iozone_bigmem_basic_xfs
	;;
	kernbench)
	${ROOT_DIR}/kernbench_disp.sh kernbench
	;;
	libmicro_bench)
	${ROOT_DIR}/libmicro_bench.sh libmicro_bench
	;;
	lmbench_bench)
	${ROOT_DIR}/lmbench_bench.sh lmbench_bench
	;;
	netperf_loop4)
	${ROOT_DIR}/netperf.sh netperf_loop4
	;;
	netperf_loop6)
	${ROOT_DIR}/netperf.sh netperf_loop6
	;;
	reaim_ioperf_ext3)
	${ROOT_DIR}/reaim_ioperf.sh reaim_ioperf_ext3
	;;
	reaim_ioperf_xfs)
	${ROOT_DIR}/reaim_ioperf.sh reaim_ioperf_xfs
	;;
	siege)
	${ROOT_DIR}/siege.sh siege
	;;
	sysbench_oltp_ext3)
	${ROOT_DIR}/sysbench.sh sysbench_oltp_ext3
	;;
	sysbench_oltp_xfs)
	${ROOT_DIR}/sysbench.sh sysbench_oltp_xfs
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
