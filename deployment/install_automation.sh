#!/bin/bash

zypper rr qa-ibs
zypper ar http://dist.suse.de/ibs/QA:/Head/SLE-12-SP1/ qa-ibs
zypper ref
zypper install qa_testset_automation
