#!/bin/bash

#awk ''
awk '/^\[.Seq.*mean/{if ($6 < -1) printf "%s **\n",$0;}/Random.*Seeks.*mean/{if ($5 < -10)printf "%s**\n" $0;}/Random.*Create.*mean/{if ($13 < -10) printf"%s**\n" $0;}'
