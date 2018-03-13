#!/bin/bash
set -eu
sudo virsh destroy $1
sudo virsh undefine $1
