#!/bin/bash -
set -e

guestname="$1"

virsh dumpxml ${guestname} >${guestname}.vm.xml

guestfish -d "${guestname}" <<EOF
	run
	mount /dev/sda2 /
	copy-in install_automation_sles12_sp4_vm.sh /root/
	mkdir /root/qaset/
	copy-in list /root/qaset/
	copy-in hostname /etc/
	copy-in config /root/qaset/
	copy-in ${guestname}.vm.xml /root
EOF
