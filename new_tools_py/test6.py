#!/usr/bin/env python3
from test7 import *

from bs4 import BeautifulSoup
import urllib
import re
from collections import OrderedDict

#html_page = urllib.request.urlopen("http://147.2.207.30/Results/ProductTests/SLES-11-SP4/")
DATAURL="http://147.2.207.30/Results/ProductTests/"
ROOTURL=DATAURL

allmachines_list = list(['apac2-ph033.apac.novell.com', 'ix64ph1054', 'apac2-ph023.apac.novell.com', 'apac2-ph022.apac.novell.com', 'apac2-ph031.apac.novell.com', 'apac2-ph027.apac.novell.com', 'apac2-ph026.apac.novell.com', 'ix64ph1053'])

DataBase=OrderedDict()
product_set = set()
release_set = set()
arch_set = set()
machine_set = set()
testcase_set = set()

testcase_list = set()

def testcase_search(html_url, testcase_dict, r, a, p, m):
    #print(html_url)
    http = urllib.request.urlopen(html_url)
    soup = BeautifulSoup(http, "lxml")
    for link in soup.findAll('a'):
        item = link.get('href')
        if re.match('^\?', item):
            continue
        if re.match('^Parent Directory$', link.getText()):
            continue
        text = link.getText().replace('/','')
        testcase_dict[text] = OrderedDict()
        testcase_set.add(text)
        try:
            testcase = TestCase(text)
        except NameError:
            continue
        if hasattr(testcase, 'name'):
            testcase.release = r
            testcase.arch = a
            testcase.product = p
            testcase.machine = m
            testcase.url = html_url
        else:
            del testcase
        testcase_list.add(testcase)
        #print(html_url+text)


def machine_search(html_url, arch_dict):
    print(html_url)
    http = urllib.request.urlopen(html_url)
    soup = BeautifulSoup(http, "lxml")
    for link in soup.findAll('a'):
        item = link.get('href')
        if re.match('^\?', item):
            continue
        if re.match('^Parent Directory$', link.getText()):
            continue
        text = link.getText().replace('/','')
        arch_dict[text] = OrderedDict()
        checklist = list(allmachines_list)
        for item in checklist:
            r = re.compile(item)
            if r.match(text):
                machine_set.add(text)
                break





def arch_search(html_url, release_dict):
    print(html_url)
    http = urllib.request.urlopen(html_url)
    soup = BeautifulSoup(http, "lxml")
    for link in soup.findAll('a'):
        item = link.get('href')
        if re.match('^\?', item):
            continue
        if re.match('^Parent Directory$', link.getText()):
            continue
        text = link.getText().replace('/','')
        release_dict[text] = OrderedDict()
        arch_set.add(text)

def release_search(html_url, product_dict):
    http = urllib.request.urlopen(html_url)
    soup = BeautifulSoup(http, "lxml")
    for link in soup.findAll('a'):
        item = link.get('href')
        if re.match('^\?', item):
            continue
        if re.match('^Parent Directory$', link.getText()):
            continue
        text = link.getText().replace('/','')
        product_dict[text] = OrderedDict()
        release_set.add(text)


def product_search(html_page):
    soup = BeautifulSoup(html_page, "lxml")
    for link in soup.findAll('a'):
        item = link.get('href')
        if re.match('^\?', item):
            continue
        if re.match('^Parent Directory$', link.getText()):
            continue
        text=link.getText().replace('/','')
        if not re.match("SLES-[0-9][0-9](-SP[0-9])*",text):
            continue
        DataBase[text] = OrderedDict()
        product_set.add(text)

homepage = urllib.request.urlopen(ROOTURL)
product_search(homepage)
for p in DataBase:
    release_search(ROOTURL+p+"/" , DataBase[p])
    for r in DataBase[p]:
        arch_search(ROOTURL+p+"/"+r+"/", DataBase[p][r])
        for a in  DataBase[p][r]:
            machine_search(ROOTURL+p+"/"+r+"/"+a+"/", DataBase[p][r][a])
            for m in DataBase[p][r][a]:
                testcase_search(ROOTURL+p+"/"+r+"/"+a+"/"+m+"/", DataBase[p][r][a][m], r, a, p, m)


print(arch_set)
print(sorted(release_set))
print(product_set)
print(machine_set)
print(testcase_set)

print(testcase_list)

#print(DataBase)
