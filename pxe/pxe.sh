#!/bin/bash
pushd /srv/tftpboot/pxelinux.cfg/confdir
sh ~/copyrename_configure_files.sh SLE15-Alpha4 SLE15-Alpha5 | sh ~/replace_label_configure_files.sh sles15-alpha4 sles15-alpha5 SLE-15-Leanos-Alpha4 SLE-15-Leanos-Alpha5
popd
