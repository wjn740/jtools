#!/bin/bash
set -eu
#This script is used to extract a testcase in SuSE/qa-testsuite with patch.
#This script will create jbuild in current directry as build root.




SOURCEDIR=`pwd`
BUILDDIR=${SOURCEDIR}/jbuild/build
RPMDIR=${SOURCEDIR}/jbuild/RPMs
SRPMDIR=${SOURCEDIR}/jbuild/SRPMs

rm ${BUILDDIR} -rf

rpmbuild --nodeps -bp --define="_sourcedir ${SOURCEDIR}" --define="_rpmdir ${RPMDIR}" --define="_srcrpmdir ${SRPMDIR}" --define="_builddir ${BUILDDIR}" $@
