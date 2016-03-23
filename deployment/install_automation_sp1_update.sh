#!/bin/bash

zypper rr qa-ibs
zypper ar http://dist.nue.suse.com/ibs/QA:/Head/SLE-12-SP1/ qa-ibs
zypper ar http://mirror.bej.suse.com/dist/ibs/SUSE/Updates/SLE-SERVER/12-SP1/x86_64/update/SUSE:Updates:SLE-SERVER:12-SP1:x86_64.repo
zypper ref

zypper -n install qa_testset_automation


zypper -n rm snapper-zypp-plugin

sed -i 's/USE_SNAPPER="yes"/#USE_SNAPPER="yes"/g' /etc/sysconfig/yast2
sed -i '/USE_SNAPPER="yes"/a USE_SNAPPER="no"' /etc/sysconfig/yast2

zypper -n rm qa_hamsta

zypper -n up kernel-default

