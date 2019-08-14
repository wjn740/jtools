#!/bin/bash

zypper rr qa-ibs
zypper ar http://dist.nue.suse.com/ibs/QA:/Head/SLE-12-SP4/ qa-ibs
zypper ar http://mirror.suse.asia/dist/install/SLP/SLE-12-SP4-SDK-LATEST/x86_64/DVD1/ qa-sdk
zypper ar http://dist.suse.de/ibs/SUSE/Products/SLE-Module-HPC/12/x86_64/product/ hpc
zypper ar http://download.suse.de/ibs/SUSE/Updates/SLE-Module-HPC/12/x86_64/update/SUSE:Updates:SLE-Module-HPC:12:x86_64.repo

zypper -n --gpg-auto-import-keys ref

zypper -n install qa_testset_automation
zypper -n install git


zypper -n rm snapper-zypp-plugin

sed -i 's/USE_SNAPPER="yes"/#USE_SNAPPER="yes"/g' /etc/sysconfig/yast2
sed -i '/USE_SNAPPER="yes"/a USE_SNAPPER="no"' /etc/sysconfig/yast2

zypper install ca-certificates-suse

zypper rm qa_hamsta


hostname > /etc/hostname

ntp_add_cmd="yast2 ntp-client add"
ntp_enable_cmd="yast2 ntp-client enable"
ntp_servers=("ntp1.suse.de" "ntp2.suse.de" "ntp3.suse.de")

for srv in ${ntp_servers[@]};do
  eval ${ntp_add_cmd} server=${srv}
done

eval ${ntp_enable_cmd}

mkdir ~/qaset/
echo "_QASET_RUNID=80000"  >> ~/qaset/config
