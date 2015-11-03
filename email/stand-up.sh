#!/bin/bash

today=`date "+%Y-%m-%d"`
mailx -v -A suse -s "[stand-up] [qa-apac2] James Wang, ${today}" qa-apac2@suse.de
