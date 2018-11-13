#!/bin/bash

parted /dev/vdb --script -- mklabel gpt
parted /dev/vdb --script -- mkpart primary xfs 32MiB -1
