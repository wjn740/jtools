#!/bin/sh


export ROOT_DIR=$(pwd)
#export NEW_LOGS_DIR=${ROOT_DIR}/new_logs_bz2
export NEW_LOGS_DIR=/home/jnwang/t3400_sp4_others_ts
export OLD_LOGS_DIR=/home/jnwang/t3400_sp3_others_ts
export HANDLER_DIR=${ROOT_DIR}/handler_directory

#sync logs from Testing Server
#pushd ${NEW_LOGS_DIR}
#rsync root@147.2.207.210:/var/log/qaset/log/* .
#popd


if ! [ -d "${OLD_LOGS_DIR}" ];then
    echo "OLD_LOGS_DIR not exist." >&2
    exit 1
fi

if ! [ -d "${NEW_LOGS_DIR}" ];then
    echo "NEW_LOGS_DIR not exist." >&2
    exit 1
fi


#acroding of new logs pick up some testcases need to compare.

testcase_list=$(ls ${NEW_LOGS_DIR}/*.tar.bz2 | awk -F '-' '{print $1}' | sort -u)
for testcase in ${testcase_list}
do
	if [ -d ${HANDLER_DIR}/$(basename ${testcase}) ] ;then
		echo "Directory existed ${HANDLER_DIR} abort."
		exit 1
	fi
	mkdir -pv ${HANDLER_DIR}/$(basename ${testcase})

	echo $(basename ${testcase}) >> ${HANDLER_DIR}/.list
done
