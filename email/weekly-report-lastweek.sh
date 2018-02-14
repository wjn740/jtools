#!/bin/bash



week=`date "+%V"`
week=$(($week - 1))
year=`date "+%G"`
mailx -v -A suse -s "[qa-reports] Workreport of week ${week}, ${year}" qa-reports@suse.de
