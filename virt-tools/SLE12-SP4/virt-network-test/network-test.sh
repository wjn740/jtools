#!/bin/bash
function setup_filesystem_and_mount
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

function start
{

		>./opensuseks.log
		>./opensuseks1.log
    logpath=`realpath ./opensuseks.log`
    logpath1=`realpath ./opensuseks1.log`
     
    virsh net-undefine testing_network
    virsh net-destroy testing_network
    virsh net-define --file network.xml 
		virsh net-start testing_network

    echo "Setup first KVM guest"
		virt-install --name opensuseks \
		--disk path=/kvm/tmpfs/opensuseks,size=7,format=qcow2,bus=virtio \
		--os-variant sles12 \
		--noautoconsole \
		--wait=-1 \
		--vnc \
		--vcpus=4 \
		--vcpus cpuset=0,2,4,8 \
		--vcpus sockets=1,cores=2,threads=2 \
		--ram=2048 \
		--console=log.file=${logpath} \
		--network bridge=br0,mac=52:54:00:C7:06:F3,model=virtio \
		--network network=testing_network,mac=52:54:00:C7:06:F4,model=virtio \
		--location=http://mirror.suse.asia/dist/install/SLP/SLE-12-SP4-Server-Alpha3/x86_64/DVD1/ \
		-x "console=ttyS0,115200n8 install=http://mirror.suse.asia/dist/install/SLP/SLE-12-SP4-Server-Alpha3/x86_64/DVD1/ autoyast=http://dashboard.qa2.suse.asia/index2/jnwang/autoyast_gnome.xml ifcfg=*=dhcp"

		virsh destroy opensuseks
		if [ $? -ne 0 ]; then
      echo "Destroy opensuseks for prepare environment failed"
			exit 1
		fi

		mv /kvm/tmpfs/opensuseks /kvm/

		EDITOR='sed -i s#/kvm/tmpfs/opensuseks#/kvm/opensuseks#g' virsh edit opensuseks

		sh guestfish.sh opensuseks

    echo "Setup Second KVM guest"
		virt-install --name opensuseks1 \
		--disk path=/kvm/tmpfs/opensuseks1,size=7,format=qcow2,bus=virtio \
		--os-variant sles12 \
		--noautoconsole \
		--wait=-1 \
		--vnc \
		--vcpus=4 \
		--vcpus cpuset=0,2,4,8 \
		--vcpus sockets=1,cores=2,threads=2 \
		--ram=2048 \
		--console=log.file=${logpath1} \
		--network bridge=br0,mac=52:54:00:C7:06:F5,model=virtio \
		--network network=testing_network,mac=52:54:00:C7:06:F6,model=virtio \
		--location=http://mirror.suse.asia/dist/install/SLP/SLE-12-SP4-Server-Alpha3/x86_64/DVD1/ \
		-x "console=ttyS0,115200n8 install=http://mirror.suse.asia/dist/install/SLP/SLE-12-SP4-Server-Alpha3/x86_64/DVD1/ autoyast=http://dashboard.qa2.suse.asia/index2/jnwang/autoyast_gnome.xml ifcfg=*=dhcp"

    virsh destroy opensuseks1
    if [ $? -ne 0 ]; then
      exit 1
    fi

		mv /kvm/tmpfs/opensuseks1 /kvm/

		EDITOR='sed -i s#/kvm/tmpfs/opensuseks1#/kvm/opensuseks1#g' virsh edit opensuseks1

		sh guestfish.sh opensuseks1

		virsh start opensuseks
		if [ $? -ne 0 ]; then
			exit 1		
		fi
		virsh start opensuseks1
		if [ $? -ne 0 ]; then
			exit 1		
		fi
		echo "Start VMs..."
		echo "Wait VMs boot up...about 180 seconds."
		sleep 180

		#sshpass -p ${password} ssh root@10.67.18.193 sh install_automation_sles12_sp4_vm.sh >/dev/null 2>&1
		#sshpass -p ${password} ssh root@10.67.18.193 "echo vm-io-test1 >/etc/hostname"  >/dev/null 2>&1
		#sshpass -p ${password} ssh root@10.67.18.193 "hostname --file /etc/hostname" >/dev/null  2>&1
		#sshpass -p ${password} ssh root@10.67.18.193 "sh ./parted-vm.sh" >/dev/null  2>&1
		#sshpass -p ${password} ssh root@10.67.18.193 "/usr/share/qa/qaset/run/performance-run.upload_Beijing" >/dev/null 2>&1

		#echo "Testing still running...."
		#while true;
		#do
		#	sshpass -p ${password} ssh root@10.67.18.193 "journalctl | grep QA_SET | grep finish" >/dev/null 2>&1
		#	if [ $? -eq 0 ]; then
		#		sshpass -p ${password} ssh root@10.67.18.193 test -f /var/log/qaset/control/DONE >/dev/null 2>&1
		#			if [ $? -eq 0 ]; then
		#				echo "Testing Done"
		#					exit 0
		#			fi
		#	fi
		#	sleep 60;
		#done
	}


function prepare ()
{
	virsh undefine opensuseks
	virsh undefine opensuseks1
	virsh destroy opensuseks
	virsh destroy opensuseks1
	
	mkdir -pv /kvm/tmpfs
	umount /kvm/tmpfs
	mount -t tmpfs tmpfs /kvm/tmpfs

}

prepare
start
