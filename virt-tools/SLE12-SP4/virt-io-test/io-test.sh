#!/bin/bash
#Testing configure
test_name="io-test"
testing_run_id="19870828"

#Host Configure
imagepool_path=/kvm
mempool_path=${imagepool_path}/tmpfs
testpool_path=${imagepool_path}/${test_name}

#Guest Configure
vm_ip_addr=10.67.18.91
vm_mac_addr=52:54:00:C7:05:F3
vm_hostname=vm-io-test
vm_domain_name=opensuseksio
vm_ram_size=2048

install_media_url="http://mirror.suse.asia/dist/install/SLP/SLE-12-SP4-Server-Alpha3/x86_64/DVD1/"
vm_install_kernel_parameter="console=ttyS0,115200n8 install=http://mirror.suse.asia/dist/install/SLP/SLE-12-SP4-Server-Alpha3/x86_64/DVD1/ autoyast=http://dashboard.qa2.suse.asia/index2/jnwang/autoyast_gnome.xml"






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

function start ()
{

		setup_filesystem_and_mount /dev/sdb2 ${testpool_path}/btrfs "mkfs.btrfs -f"
		setup_filesystem_and_mount /dev/sdb3 ${testpool_path}/ext4  "mkfs.ext4 -F"
		setup_filesystem_and_mount /dev/sdb4 ${testpool_path}/xfs	"mkfs.xfs -f"

		>/root/${vm_domain_name}.log


		#fixme
		fs=xfs
		addon_disk="--disk path=${testpool_path}/${fs}/${vm_domain_name},size=7,format=raw,bus=virtio"

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
		--console=log.file=/root/${vm_domain_name}.log \
		--network bridge=br0,mac=${vm_mac_addr},model=virtio \
		--location="${install_media_url}" \
		-x "${vm_install_kernel_parameter}"

		if [ $? -eq 0 ]; then
			virsh destroy ${vm_domain_name}
			if [ $? -ne 0 ]; then
				exit 1
			fi
		else 
			virsh destroy ${vm_domain_name}
			exit 1
		fi


		mv /kvm/tmpfs/${vm_domain_name} /kvm/

		EDITOR='sed -i s#/kvm/tmpfs/${vm_domain_name}#/kvm/${vm_domain_name}#g' virsh edit ${vm_domain_name}


		sh guestfish.sh ${vm_domain_name}

		virsh start ${vm_domain_name}
		if [ $? -ne 0 ]; then
			exit 1		
		fi
		echo "Start VM..."
		echo "Wait VM boot up...about 180 seconds."
		sleep 180
}


function prepare ()
{
	virsh undefine ${vm_domain_name}
	virsh destroy ${vm_domain_name}
	
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
