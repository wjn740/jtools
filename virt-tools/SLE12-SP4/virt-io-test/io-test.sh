#!/bin/bash
#Testing configure
test_name="io-test"
testing_run_id="19870828"
test_fs=xfs

#Host Configure
imagepool_path=/kvm
mempool_path=${imagepool_path}/tmpfs
testpool_path=${imagepool_path}/${test_name}

#Guest Configure
vm_ip_addr=10.67.18.91
vm_mac_addr=52:54:00:C7:05:F3
vm_hostname=vm-io-test
vm_domain_name=apple1
vm_ram_size=2048
vm_serial_log=${testpool_path}/${vm_domain_name}.serial.log

install_media_url="http://mirror.suse.asia/dist/install/SLP/SLE-12-SP4-Server-Alpha3/x86_64/DVD1/"
sha1no=`echo ${install_media_url} | sha1sum | awk '{print $1}'`
vm_install_kernel_parameter="console=ttyS0,115200n8 install=http://mirror.suse.asia/dist/install/SLP/SLE-12-SP4-Server-Alpha3/x86_64/DVD1/ autoyast=http://dashboard.qa2.suse.asia/index2/jnwang/autoyast_gnome.xml"

#QASET configure
cat <<EOF >config
_QASET_RUNID=${testing_run_id}
EOF
#QASET list
cat <<EOF >list
SQ_ABUILD_PARTITION=/dev/vdb1
SQ_TEST_RUN_LIST=(
io_block_generic_iozone_fsync_${test_fs}
)
EOF


function setup_filesystem_and_mount ()
{
#$1 is a block device
#$2 is a directory that will be mounted by $1.
#$3 is a filesystem tool that be used to as a tool to format $1.

	if ! test -b "$1"; then
		echo "$1" "is not a block device"
		exit 1
	fi

	if ! test -d "$2"; then
		mkdir -pv "$2"
		if [ $? -ne 0 ]; then
			logger "Can't create a directory on filesystem."
			exit 1
		fi
	fi

	$3 $1

	mount $1 $2
	if [ $? -ne 0 ]; then
		logger "Can't create a directory on filesystem."
	fi
	
}

function install_vm ()
{
		#fixme
		addon_disk="--disk path=${testpool_path}/${test_fs}/${vm_domain_name},size=7,format=raw,bus=virtio"

		virt-install --name ${vm_domain_name} \
		--disk path=${mempool_path}/${vm_domain_name},size=7,format=qcow2,bus=virtio \
		${addon_disk} \
		--os-variant sles12 \
		--noautoconsole \
		--wait=-1 \
		--vnc \
		--vcpus=4 \
		--vcpus cpuset=0,2,4,8 \
		--vcpus sockets=1,cores=2,threads=2 \
		--ram=${vm_ram_size} \
		--console=log.file=${vm_serial_log} \
		--network bridge=br0,mac=${vm_mac_addr},model=virtio \
		--location="${install_media_url}" \
		-x "${vm_install_kernel_parameter}"


		mv ${mempool_path}/${vm_domain_name} ${imagepool_path}

		mv ${imagepool_path}/${vm_domain_name} ${imagepool_path}/${vm_domain_name}.${sha1no}
		qemu-img create -f qcow2 -b ${imagepool_path}/${vm_domain_name}.${sha1no} ${imagepool_path}/${vm_domain_name}

		EDITOR="sed -i s#${mempool_path}/${vm_domain_name}#${imagepool_path}/${vm_domain_name}#g" virsh edit ${vm_domain_name}


		sh guestfish.sh ${vm_domain_name}

		virsh start ${vm_domain_name}
		if [ $? -ne 0 ]; then
			exit 1		
		fi
		echo "Start VM..."
		echo "Wait VM boot up...about 180 seconds."
		sleep 180

}
function start ()
{

		setup_filesystem_and_mount /dev/sdb2 ${testpool_path}/btrfs "mkfs.btrfs -f"
		setup_filesystem_and_mount /dev/sdb3 ${testpool_path}/ext4  "mkfs.ext4 -F"
		setup_filesystem_and_mount /dev/sdb4 ${testpool_path}/xfs	"mkfs.xfs -f"

		>${vm_serial_log}
		
		#fastpath if the img is exist
		if [ -f ${imagepool_path}/${vm_domain_name}.${sha1no} ]; then
			qemu-img create -f qcow2 -b ${imagepool_path}/${vm_domain_name}.${sha1no} ${imagepool_path}/${vm_domain_name}
			
			addon_disk="--disk path=${testpool_path}/${test_fs}/${vm_domain_name},size=7,format=raw,bus=virtio"

			virt-install --name ${vm_domain_name} \
			--disk path=${imagepool_path}/${vm_domain_name},size=7,format=qcow2,bus=virtio \
			--import \
			${addon_disk} \
			--os-variant sles12 \
			--noautoconsole \
			--vnc \
			--vcpus=4 \
			--vcpus cpuset=0,2,4,8 \
			--vcpus sockets=1,cores=2,threads=2 \
			--memory=${vm_ram_size} \
			--console=log.file=${vm_serial_log} \
			--network bridge=br0,mac=${vm_mac_addr},model=virtio

			(tail -f -n0 ${vm_serial_log}&) | grep -q "Welcome to SUSE"

			virsh destroy ${vm_domain_name}
			if [ $? -ne 0 ]; then
				exit 1
			fi

			echo "Guestfish is working......."
			sh guestfish.sh ${vm_domain_name}
			echo "Guestfish is working done"

			echo "Start ${vm_domain_name}"
			virsh start ${vm_domain_name}
			if [ $? -ne 0 ]; then
				exit 1		
			fi
			echo "Start VM..."
			(tail -f -n0 ${vm_serial_log}&) | grep -q "Welcome to SUSE"
		else
			install_vm
		fi
}


function prepare ()
{
	virsh undefine ${vm_domain_name}
	virsh destroy ${vm_domain_name}
	
	find ${imagepool_path} -name ${vm_domain_name} -delete
	
	mkdir -pv /kvm/tmpfs
	umount /kvm/tmpfs
	mount -t tmpfs tmpfs /kvm/tmpfs

	umount /dev/sdb*	

	if test -b /dev/sdb; then
		parted /dev/sdb --script -- mklabel gpt
		parted /dev/sdb --script -- mkpart primary xfs 32MiB 70GiB
		parted /dev/sdb --script -- mkpart primary btrfs 70GiB 90GiB
		parted /dev/sdb --script -- mkpart primary ext4 90GiB 100GiB
		parted /dev/sdb --script -- mkpart primary xfs 100GiB 110GiB
	fi	


}


function do_test ()
{
		sshpass -p susetesting ssh root@${vm_ip_addr} sh install_automation_sles12_sp4_vm.sh >/dev/null
		sshpass -p susetesting ssh root@${vm_ip_addr} "echo ${vm_hostname} >/etc/hostname"  >/dev/null
		sshpass -p susetesting ssh root@${vm_ip_addr} "hostname --file /etc/hostname" >/dev/null
		sshpass -p susetesting ssh root@${vm_ip_addr} "sh ./parted-vm.sh" >/dev/null
		sshpass -p susetesting ssh root@${vm_ip_addr} "/usr/share/qa/qaset/run/performance-run.upload_Beijing" >/dev/null 2>&1
		echo "Testing still running...."

}


function check_files
{
	if ! [ -f ./list ]; then
		echo "the list file is missing"
	fi
	if ! [ -f ./config ]; then
		echo "the config file is missing"
	fi
	if ! [ -f ./hostname ]; then
		echo "the hostname file is missing"
	fi
	if ! [ -f ./parted-vm.sh ]; then
		echo "the parted-vm.sh file is missing"
	fi
	if ! [ -f ./guestfish.sh ]; then
		echo "the guestfish.sh file is missing"
	fi
}

function wait_for_jobs_done
{
		while true;
		do
			sshpass -p susetesting ssh root@${vm_ip_addr} "journalctl | grep QA_SET | grep finish" >/dev/null 2>&1
			if [ $? -eq 0 ]; then
				sshpass -p susetesting ssh root@${vm_ip_addr} test -f /var/log/qaset/control/DONE >/dev/null 2>&1
					if [ $? -eq 0 ]; then
						echo "Testing Done"
							exit 0
					fi
			fi
			sleep 60;
		done

}

check_files
prepare
start
do_test
wait_for_jobs_done
