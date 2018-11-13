#!/bin/bash
set -eu
virt-install --connect qemu:///system \
--name $1 \
--ram 1024 \
--os-variant sles15 \
--disk path=./$1.qcow2,format=qcow2,bus=virtio,cache=none,size=19 \
--network type=direct,source=br0,model=virtio \
--accelerate \
--pxe \
--noautoconsole \
--vcpus 2,cpuset=3,7

virt-viewer -c qemu:///system $1




#--cpu host-passthrough,+pcid,+invpcid
#--cpu host-model,+pcid,+invpcid
