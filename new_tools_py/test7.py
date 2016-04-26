#!/usr/bin/env python3

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
        self.name = ""
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

    def __init_(self):
        self.name = ""
        self.subtestcases = list()
        self.url = ""
        self.machine = ""
        self.arch = ""
        self.release = ""
        self.product = ""
        self.kernel = ""
