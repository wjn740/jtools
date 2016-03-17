#!/bin/bash
set -u

#get parition names from sysfs
pushd /sys/class/block >/dev/null
list=`ls`
popd >/dev/null

#set a mount pointer
mountpoint=/mnt/t

#setup mount directory
mkdir -pv ${mountpoint} >/dev/null

#walk the partition list.
echo "================================="
#echo "Hostname" ';' 'Partition' ';' 'Products' ';' "Kernel Version" ';' "Build NO." ';' 
for dev in $list
do
mount -o ro /dev/$dev $mountpoint >/dev/null 2>&1
if [ $? -ne 0 ]; then
    continue
fi
if [ -f ${mountpoint}/etc/os-release ]; then
    echo $(hostname) ";" "$dev" ";" $(cat ${mountpoint}/etc/os-release | grep PRETTY_NAME | awk -F "=" '{print $2}' | sed 's/"//g') ";"  $(ls ${mountpoint}/boot/vmlinuz-?*-* | tail -n 1 | awk -F "vmlinuz-" '{print $2}') ";" $(cat ${mountpoint}/etc/YaST2/build | rev | awk -F "-" '{print $1}' | rev)
fi
umount $mountpoint >/dev/null
done
echo "================================="

rm /mnt/t -rvf >/dev/null
