#!/usr/bin/env python3

from test7 import TestCase

a = TestCase("kernbench-2016-03-22-20-15-55")

try:
    b = TestCase("dbench4_fsync_root-2016-03-31-06-11-06")
except NameError:
    pass



print (a.name)
