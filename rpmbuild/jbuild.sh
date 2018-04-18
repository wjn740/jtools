#!/bin/bash
set -eu
#This script is used to build a testcase in SuSE/qa-testsuite.
#This script will create rpmbuild in current directry as build root.




SOURCEDIR=`pwd`
BUILDDIR=${SOURCEDIR}/jbuild/build
RPMDIR=${SOURCEDIR}/jbuild/RPMs
SRPMDIR=${SOURCEDIR}/jbuild/SRPMs

rm ${BUILDDIR} -rf

rpmbuild -bc --define="_builddir ${BUILDDIR}" --define="_sourcedir ${SOURCEDIR}" --define="_rpmdir ${RPMDIR}" --define="_srcrpmdir ${SRPMDIR}" $@
