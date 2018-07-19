#!/bin/bash

virsh destroy apple1
virsh undefine apple1
umount /dev/sd??
rm /kvm/* -rf
umount /kvm/tmpfs

