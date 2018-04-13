#!/bin/bash


/usr/share/qa/tools/install.pl -o "addon=$2 console=ttyS0,115200n8 ssh=1 sshpassword=${password}" -p "$1"
sed -i 's/auto.*\.xml //g' /boot/grub2/grub.cfg
