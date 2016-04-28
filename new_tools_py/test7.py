#!/usr/bin/env python3

import re

class TestItem():
    """testitem is a testing item in a subtestcase
        For example:
            In IOzone, there are some testitem : read, write, reread, rewrite, random read, random write and so on.

        Attributes:
        @name, the testing name. the above example, "read" "write" "random read".
        @value, the benchmark value for this testing item.
        @value_type, the type of this benchmark, speed or time. it indcate more high more good or  more low more good.
        @subtestcase, the pointer to the parent subtestcase.
    """
    def __init__(self):
        self.name = ""
        self.value = ""
        self.value_type = ""
        self.subtestcase = ""

class SubTestCase():
    """
        SubTestCase is the one of testcase in a logdir. sometime there are more one testing log in logdir, each of them be called subtestcase, each subtestcase might be include some testitems, usually.
        @name, the name of a subtestcase object.
        @testitems, this is a list to include all of testitems in this subtestcase.
        @testcase, the pointer to the parent testcase.
    """
    def __init__(self):
        self.subname = ""
        self.testitems = list()
        self.testcase = ""

class TestCase():
    """
        TestCase is the one item of running list. It include some subtestcases.
        @name, the name of a testcase.
        @subtestcases, the list of subtestcase.
        @url, The URL of store.
        @machine, The machine of testcase.
        @arch, The arch of the machine of testcase.
        @release, The release of product.
        @product, The product of testcaes.
        @kernel, The kernel of product. Sometimes kernel version is different.
    """
    def __str__(self):
        try:
            #print(self.name)
            #print(self.subtestcases)
            #print(self.url)
            pass
            #print(self.machine)
            #print(self.arch)
            #print(self.release)
            #print(self.product)
            #print(self.kernel)
        except AttributeError:
            pass
        return self.name

    def check_testcase_name(self, name):
        checklist = list(["qa_siege_performance",
                "sysbench-sys",
                "libmicro-bench",
                "lmbench",
                "kernbench",
                "reaim-alltest",
                "netperf-peer-loop",
                "netperf-peer-loop6",
                "reaim_disk_ext3",
                "reaim_disk_xfs",
                "reaim_disk_btrfs",
                "reaim_disk_ext4",
                "qa_iozone_doublemem_ext3",
                "qa_iozone_doublemem_xfs",
                "qa_iozone_doublemem_btrfs",
                "qa_iozone_doublemem_ext4",
                "qa_tiobench_async_ext3",
                "qa_tiobench_async_xfs",
                "qa_tiobench_async_btrfs",
                "qa_tiobench_async_ext4",
                "bonnie\+\+_async_ext3",
                "bonnie\+\+_async_xfs",
                "bonnie\+\+_async_btrfs",
                "bonnie\+\+_async_ext4",
                "bonnie\+\+_fsync_ext3",
                "bonnie\+\+_fsync_xfs",
                "bonnie\+\+_fsync_btrfs",
                "bonnie\+\+_fsync_ext4",
                "sysbench_oltp_ext3",
                "sysbench_oltp_xfs",
                "sysbench_oltp_btrfs",
                "sysbench_oltp_ext4",
                "dbench4_async_ext3",
                "dbench4_async_xfs",
                "dbench4_async_btrfs",
                "dbench4_async_ext4",
                "pgbench_small_rw_ext3",
                "pgbench_small_rw_xfs",
                "pgbench_small_rw_btrfs",
                "pgbench_small_rw_ext4",
                "pgbench_small_ro_ext3",
                "pgbench_small_ro_xfs",
                "pgbench_small_ro_btrfs",
                "pgbench_small_ro_ext4",
                "dbench4_fsync_ext3",
                "dbench4_fsync_xfs",
                "dbench4_fsync_btrfs",
                "dbench4_fsync_ext4"])
        for item in checklist:
            r = re.compile(item)
            if r.match(name):
                print(">>_+OK+_")
                return
        raise NameError('Name Wrong')

    def __init__(self, n="", r="", a="", p="", m="", u="", k=""):
        try:
            self.check_testcase_name(n)
        except NameError:
            raise NameError("Testcase's name is invaild")
            return

        self.name = n
        self.subtestcases = list()
        self.url = u
        self.machine = m
        self.arch = a
        self.release = r
        self.product = p
        self.kernel = k


class product():
    def __init__(self):
        self.product = ""
