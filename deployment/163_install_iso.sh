#!/bin/bash

REPO_URL="http://147.2.207.1/dist/install/SLP/SLE-12-SP1-Server-RC1/x86_64/DVD1/"
ROOT_PT="/dev/sda1"

/usr/share/qa/tools/install.pl -p ${REPO_URL}  -f default -t base -Z asia_beijing -z ${ROOT_PT}
