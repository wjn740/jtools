#!/bin/bash
set -eu

good_commit=''
bad_commit=''

host_ip='147.2.208.110'

while true
do
i=1
PS1='git-bisect>'

pushd suse-kernel 2>&1 >/dev/null

if [ $? -ne 0 ]; then
    exit
fi

#Into Shell, Using git-bisect to choose the reversion.

echo "Remove the old directory at remote machine."

sshpass -p '${password}' ssh root@${host_ip} screen -dm rm -rf suse-kernel-bisect/

echo "Creating archive"

git archive --format=tar --prefix=suse-kernel-bisect/ HEAD | bzip2 > ../suse-kernel-bisect.bz2

echo "Copying archive to remote host"
sshpass -p '${password}' scp ../suse-kernel-bisect.bz2 root@${host_ip}:

echo "Extracting archive at remote host"
sshpass -p '${password}' ssh root@${host_ip} tar xf ./suse-kernel-bisect.bz2

suse_commit_hash=`git log -1 | grep 'suse-commit' | awk -F ": " '{print $2}'`


popd

pushd kernel-source

git checkout ${suse_commit_hash}

cp config/x86_64/default .
sed -i '/CONFIG_LOCALVERSION=/d' default
sed -i "/CONFIG_LOCALVERSION_AUTO/i\CONFIG_LOCALVERSION='-default-jnwang-${suse_commit_hash:1:8}'" default
sshpass -p '${password}' scp default root@${host_ip}:suse-kernel-bisect/.config

popd

#ssh root@${host_ip} "pushd suse-kernel-bisect && make localmodconfig"
echo "Entering Directory ~/suse-kernel-bisect/  Run: make localmodconfig"
echo "And exit this shell via 'exit 0' without do anything else"
sshpass -p '${password}' ssh root@${host_ip}

if [ $? -ne 0 ]; then
    exit
fi

sshpass -p '${password}' ssh root@${host_ip} "pushd suse-kernel-bisect && screen -dmSL kenrel-building make binrpm-pkg -j16"


echo "Checking build progress..........."
echo "When you exit this shell the next round will be start..........."
echo "You could use 'exit 1' to abort this script."
bash
if [ $? -ne 0 ]; then
    exit
fi
((i++))
done
