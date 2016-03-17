#!/bin/bash

yesterday=`date -d "yesterday" "+%Y-%m-%d"`
mailx -v -A suse -s "[stand-up] [qa-apac2] James Wang, ${yesterday}" qa-apac2@suse.de
