#!/bin/bash

awk '/mean/{if ($8 < -10) printf "%s **\n",$0; else print $0}'
