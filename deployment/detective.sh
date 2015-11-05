#!/bin/bash
while true;
do
curl ftp://mirror.bej.suse.com/dist/install/SLP/SLE-12-SP1-Server-RC3-A/x86_64/DVD1/
if [ $? -eq 0 ]; then
~/installer.sh http://mirror.bej.suse.com/dist/install/SLP/SLE-12-SP1-Server-RC3-A/x86_64/DVD1/
else
sleep 200;
fi
done
