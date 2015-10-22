#!/bin/bash

grep "mean" | awk '{if ($4 < -10) printf "%s **\n",$0; else print $0}'
