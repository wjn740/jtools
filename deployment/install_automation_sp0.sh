#!/bin/bash

zypper ar http://download.suse.de/ibs/SUSE/Updates/SLE-SERVER/12/x86_64/update/ update-sles12-sp0

zypper in kernel-default-3.12.44-52.10

zypper rr qa-ibs
zypper ar http://dist.suse.de/ibs/QA:/Head/SLE-12/ qa-ibs
zypper ref

zypper -n install qa_testset_automation


zypper -n rm snapper-zypp-plugin

sed -i 's/USE_SNAPPER="yes"/#USE_SNAPPER="yes"/g' /etc/sysconfig/yast2
sed -i '/USE_SNAPPER="yes"/a USE_SNAPPER="no"' /etc/sysconfig/yast2

zypper -n rm qa_hamsta
