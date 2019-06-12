#!/bin/bash
set -eu
sudo mkdud --create bsc1108943.dud --dist sles12 --condition ServicePack4 --name 'kernel update for bsc1108943' for-iso/*
sudo mksusecd --create SLE-12-SP4-Server-DVD-x86_64-RC1-DVD1-bsc1108943.iso --initrd bsc1108943.dud --kernel for-iso/kernel-*.rpm --addon for-iso/* --addon-name "kernel update for bsc#1108943" -- ./SLE-12-SP4-Server-DVD-x86_64-RC1-DVD1.iso
