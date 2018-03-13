#!/bin/bash
set -eu
virt-install --connect qemu:///system \
--name $1 \
--ram 1024 \
--os-variant sles15 \
--disk path=./test.qcow2,format=qcow2,bus=virtio,cache=none,size=19 \
--network type=direct,source=eth0,model=virtio \
--accelerate \
--pxe \
--noautoconsole \
--cpu model='Haswell-noTSX',require=pcid,require=invpcid

virt-viewer -c qemu:///system test




#--cpu host-passthrough,+pcid,+invpcid
#--cpu host-model,+pcid,+invpcid
