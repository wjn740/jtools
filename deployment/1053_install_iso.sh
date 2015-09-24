#!/bin/bash

REPO_URL="http://download.suse.de/install/SLP/SLE-12-SP1-Server-RC1/x86_64/DVD1/"
ROOT_PT="/dev/sda2"

/usr/share/qa/tools/install.pl -p ${REPO_URL}  -f default -t base -Z Europe_Berlin -z ${ROOT_PT}
