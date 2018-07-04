Project Desgin Document

For performance testing for VM. (KVM)

Host Hypervisor performance testing is depend on qa_testset_automation. So we need a framework to do performance testing for Guest of KVM.

Requirement:

1. The tools should use qa_testset_automation as testcase runner.
2. This framework should be running in Host hypervisor.
  a). 
  b).
  c).

3. This framework should use libvirt/API as management interface.

4. This framework must be a full automation implement.

Detail:

KVM performance testing has more level than Hypervisor performance testing.

Environment Preparetion


Installation

YaST

#!/bin/bash

#Prepare Environment
mkdir -pv /kvm/tmpfs
mount -t tmpfs tmpfs /kvm/tmpfs

#Install VM
#!/bin/bash
virt-install --name opensuseks \
    --disk path=/kvm/opensuseks,size=20,format=qcow2,bus=virtio,cache=none \
    --os-variant sles12 \
    --noautoconsole \
    --wait=-1 \
    --vnc \
    --vcpus=4 \
    --ram=1024 \
    --console=log.file=/root/vm-install.log \
    --network bridge=br0,mac=52:54:00:C7:06:F3,model=virtio \
    --location=http://mirror.suse.asia/dist/install/SLP/SLE-12-SP4-Server-Alpha3/x86_64/DVD1/ \
    -x "console=ttyS0,115200n8 install=http://mirror.suse.asia/dist/install/SLP/SLE-12-SP4-Server-Alpha3/x86_64/DVD1/ autoyast=http://dashboard.qa2.suse.asia/index2/jnwang/autoyast_gnome.xml"
if [ $? eq 0 ]; then
  virsh destroy vm-perf-test 
fi


Manually


Deployment

#!/bin/bash -
set -e

guestname="$1"

guestfish -d "${guestname}" <<'EOF'
run
mount /dev/sda2 /
#Deployment script
copy-in install_automation_sles12_sp4_vm.sh /
#Running list
copy-in james_care.list /
EOF



IO testing

In Hypervisor performance testing.

I/O testing use /dev/sdb1, /dev/sdc1 directly.


In KVM performance testing, 
   

                    
                   (QASET in KVM Guest) --- Testing running here.

       [ Filesystem ]
      {/dev/vdb1,/dev/vdc1}                                 kvm
  -------------------------------------------------------------------
               \                                            host
                \
            (KVM performance testing framework) --- This framework.
              /
             /
          (File)
      [Filesystem]
{/dev/sdb1,/dev/sdc1}

Prepare partition in Guest:
Add a VDisk into Guest:
<fixme>

Parted this disk:
parted /dev/vdb --script -- mkpart primary 0 -1




Network testing


                   (QASET in KVM Guest) --- Testing running here.

       
      {interface1}     {interface}     {interface}                        kvm
  ----------------------------------------------------------------------------
               \            |____________|                                host
                \
            (KVM performance testing framework) --- This framework.
              /
             /
{interface}

