#!/usr/bin/env python3
from test7 import *

from bs4 import BeautifulSoup
import urllib
import re
from collections import OrderedDict

#html_page = urllib.request.urlopen("http://147.2.207.30/Results/ProductTests/SLES-11-SP4/")
DATAURL="http://147.2.207.30/Results/ProductTests/"
ROOTURL=DATAURL

DataBase=OrderedDict()
product_set = set()
release_set = set()
arch_set = set()
machine_set = set()
testcase_set = set()

def testcase_search(html_url, testcase_dict, testcase):
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
        testcase_dict[text] = OrderedDict()
        testcase_set.add(text)
        testcase.name = text
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
        machine_set.add(text)


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
                testcase = TestCase()
                testcase_search(ROOTURL+p+"/"+r+"/"+a+"/"+m+"/", DataBase[p][r][a][m], testcase)
                if hasattr(testcase, 'name'):
                    testcase.release = r
                    testcase.arch = a
                    testcase.product = p
                    testcase.machine = m
                    print("==>",testcase)
                else:
                    del testcase


print(arch_set)
print(release_set)
print(product_set)
print(machine_set)
print(testcase_set)

#print(DataBase)
