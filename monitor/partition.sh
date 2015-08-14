#!/bin/bash




pushd /sys/class/block
list=`ls`
popd


mountpoint=/mnt/t

mkdir -pv ${mountpoint}


for dev in $list
do


mount /dev/$dev $mountpoint >/dev/null 2>&1

if [ $? -ne 0 ]; then
    continue
fi

if [ -f $mountpoint/etc/issue ]; then
echo "================================="
    echo "$dev:"
    cat $mountpoint/etc/issue
echo "================================="
fi


umount $mountpoint

done

rm /mnt/t -rvf

