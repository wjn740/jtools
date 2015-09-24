#!/bin/bash


/usr/share/qa/tools/install.pl -o "console=ttyS0,115200n8 ssh=1 sshpassword=${password}" -p "$@"
sed -i 's/auto.*\.xml //g' /boot/grub2/grub.cfg
