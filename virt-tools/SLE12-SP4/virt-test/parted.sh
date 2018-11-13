#!/bin/bash

parted /dev/sdb --script -- mklabel gpt
parted /dev/sdb --script -- mkpart primary xfs 32MiB 70GiB
parted /dev/sdb --script -- mkpart primary btrfs 70GiB 90GiB
parted /dev/sdb --script -- mkpart primary ext4 90GiB 100GiB
parted /dev/sdb --script -- mkpart primary xfs 100GiB 110GiB

