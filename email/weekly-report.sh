#!/bin/bash



week=`date "+%V"`
year=`date "+%G"`
mailx -v -A suse -s "[qa-reports] Workreport of week ${week}, ${year}" qa-reports@suse.de
