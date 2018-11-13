#!/bin/bash

function start
{
	mkdir -pv /kvm/tmpfs
		umount /kvm/tmpfs
		mount -t tmpfs tmpfs /kvm/tmpfs

		>/root/opensuseks.log

		virsh undefine opensuseks
		virsh destroy opensuseks


		virt-install --name opensuseks \
		--disk path=/kvm/tmpfs/opensuseks,size=7,format=qcow2,bus=virtio \
		--os-variant sles12 \
		--noautoconsole \
		--wait=-1 \
		--vnc \
		--vcpus=4 \
		--vcpus cpuset=0,2,4,8 \
		--vcpus sockets=1,cores=2,threads=2 \
		--ram=1024 \
		--console=log.file=/root/opensuseks.log \
		--network bridge=br0,mac=52:54:00:C7:06:F3,model=virtio \
		--location=http://mirror.suse.asia/dist/install/SLP/SLE-12-SP4-Server-Alpha3/x86_64/DVD1/ \
		-x "console=ttyS0,115200n8 install=http://mirror.suse.asia/dist/install/SLP/SLE-12-SP4-Server-Alpha3/x86_64/DVD1/ autoyast=http://dashboard.qa2.suse.asia/index2/jnwang/autoyast_gnome.xml"



		if [ $? -eq 0 ]; then
			virsh destroy opensuseks
		else 
			virsh destroy opensuseks
				exit 1
		fi


		mv /kvm/tmpfs/opensuseks /kvm/

		EDITOR='sed -i s#/kvm/tmpfs/opensuseks#/kvm/opensuseks#g' virsh edit opensuseks


		sh guestfish.sh opensuseks

		virsh start opensuseks
		echo "Start VM..."
		echo "Wait VM boot up...about 180 seconds."
		sleep 180

		sshpass -p ${password} ssh root@10.67.18.193 sh install_automation_sles12_sp4_vm.sh >/dev/null 2>&1
		sshpass -p ${password} ssh root@10.67.18.193 "echo vm-test1 >/etc/hostname"  >/dev/null 2>&1
		sshpass -p ${password} ssh root@10.67.18.193 "hostname --file /etc/hostname" >/dev/null  2>&1
		sshpass -p ${password} ssh root@10.67.18.193 "/usr/share/qa/qaset/run/performance-run.upload_Beijing" >/dev/null 2>&1

		echo "Testing still running...."
		while true;
		do
			sshpass -p ${password} ssh root@10.67.18.193 "journalctl | grep QA_SET | grep finish" 2>&1 >/dev/null
				if [ $? -eq 0 ]; then
					sshpass -p ${password} ssh root@10.67.18.193 test -f /var/log/qaset/control/DONE 2>&1 >/dev/null
						if [ $? -eq 0 ]; then
							echo "Testing Done"
								exit 0
								fi
								fi
								sleep 360;
		done
	}

screen -dL start
