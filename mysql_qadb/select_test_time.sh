#!/bin/bash
set -eu
host_list = "apac2-ph023.bej.suse.com apac2-ph031.bej.suse.com apac2-ph022.bej.suse.com apac2-ph027.bej.suse.com apac2-ph026.bej.suse.com ix64ph1053.qa.suse.de ix64ph1054.qa.suse.de"
for host in ${host_list}
do
mysql -u root -h 147.2.207.30 -D qadb -e "select * from performance_view where \`host\` = ${host} and \`product\` = 'SLES-12-SP1' and \`arch\` = 'x86_64' and \`release\` = 'GM' and \`kernel_version\` = '3.12.57'"> "${host#bej.suse.com}.txt"
done
