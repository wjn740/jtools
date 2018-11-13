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

Host environment setup steps:
1. A independed disk for IO test.
/dev/sdb
2. parted it to different partition.
#!/bin/bash
parted /dev/sdb --script -- mklabel gpt
parted /dev/sdb --script -- mkpart primary xfs 32MiB 70GiB
parted /dev/sdb --script -- mkpart primary btrfs 70GiB 90GiB
parted /dev/sdb --script -- mkpart primary ext4 90GiB 100GiB
parted /dev/sdb --script -- mkpart primary xfs 100GiB 110GiB

3. format all partitions to different filesystems.(xfs, btrfs, ext4)
mkfs.xfs -f /dev/sdb1
mkfs.btrfs -f /dev/sdb2
mkfs.ext4 -F /dev/sdb3
mkfs.xfs -f /dev/sdb4

4. layout of partitions is needed to desgin.
First partition be use to store the image that will setup OS system.
Other partitions be use to store the image that as secondary disk for performance testing in VM.

Installation

YaST

#!/bin/bash

#Prepare Environment
mkdir -pv /kvm/tmpfs
mkdir -pv /kvm/btrfs
mkdir -pv /kvm/ext4
mkdir -pv /kvm/tmpfs

#Mount all directory
mount /dev/sdb1 /kvm
mount /dev/sdb2 /kvm/btrfs
mount /dev/sdb3 /kvm/ext4
mount /dev/sdb4 /kvm/xfs
mount -t tmpfs tmpfs /kvm/tmpfs

#Install VM
#!/bin/bash
virt-install --name opensuseks \
    --disk path=/kvm/opensuseks,size=20,format=qcow2,bus=virtio,cache=none \
    --disk path=/kvm/xfs/iotest,size=10,format=qcow2,bus=virtio,cache=none \
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

Task management

Running management



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

CPU Bound testing

CPU topology configure

NUMA / SMP / Multi-threads configure secnarios.


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

