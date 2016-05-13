#!/bin/bash
set -eu

kernel_version="3.12.57"

mysql -u qadb -h 147.2.207.30 -D qadb -p -e "select distinct \`testsuite\` from performance_view  where \`kernel_version\` = '3.12.57' order by \`testsuite\` asc;"
