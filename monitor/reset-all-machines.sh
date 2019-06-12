#!/bin/bash
set -eu

ipmitool -H ph022-ipmi.qa2.suse.asia -U root -P susetesting -I lanplus power reset
ipmitool -H ph027-ipmi.qa2.suse.asia -U root -P susetesting -I lanplus power reset
ipmitool -H ph038-ipmi.qa2.suse.asia -U root -P susetesting -I lanplus power reset
ipmitool -H ph039-ipmi.qa2.suse.asia -U root -P susetesting -I lanplus power reset
ipmitool -H ph040-ipmi.qa2.suse.asia -U root -P susetesting -I lanplus power reset
ipmitool -H ph041-ipmi.qa2.suse.asia -U root -P susetesting -I lanplus power reset
ipmitool -H ph042-ipmi.qa2.suse.asia -U root -P susetesting -I lanplus power reset
ipmitool -H ph043-ipmi.qa2.suse.asia -U root -P susetesting -I lanplus power reset

