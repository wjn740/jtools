#!/bin/bash

awk '/mean/{if ($5 < -10) printf "%s **\n",$0; else print $0}'
