#!/bin/bash
ftp -n <<EOF
open beta.suse.com
user anonymous ""
cd incoming
put testing_status.txt
EOF
