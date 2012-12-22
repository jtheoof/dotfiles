#!/usr/bin/python

## @package log-parser
#  Provides general functions to parse log and crash reports in order
#  to generate a CSV or EXCEL file with statics on specific stores.

import calendar
import csv
import datetime
import fnmatch
import getopt
import logging
import os
import platform
import random
import re
import shutil
import string
import sys
import time
import urllib

## Main logger
#
#  There are two loggers:
#    1. A file logger starting a WARNING level
#    2. A console logger starting a DEBUG level
logger = logging.getLogger('gw2w')
logger.setLevel(logging.DEBUG)
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
ch.setFormatter(formatter)
logger.addHandler(ch)

GUILD_WARS_URL = 'http://www.guildwars2.com'

class Wallpaper:
	def __init__(self):
		pass

def get_wallpaper_page(url):
	logger.debug('retrieving content in url: %s' % url)
	try:
		data = open('/tmp/gw2w.html').read()
	except IOError:
		data = urllib.urlopen(url).read()
		cache = open('/tmp/gw2w.html', 'w')
		cache.write(data)
	return data

def download_wallpaper(url):
	name = url.split('/')[-1]
	logger.info('downloading: %s' % name)
	filepath = os.path.join(os.curdir, name)
	if not os.path.exists(filepath):
		data = urllib.urlopen('%s%s' % (GUILD_WARS_URL, url)).read()
		open(filepath, 'w').write(data)
	else:
		logger.info('%s already found, skipping', name)

def parse_page(source, dimensions):
	pattern = re.compile(r'href="(.*?)".%s' % dimensions)
	wallpapers = pattern.findall(source)
	logger.info('found %d files' % len(wallpapers))
	for w in wallpapers:
		download_wallpaper(w)

## Print usage of the package.
def usage():
	basename = os.path.basename(sys.argv[0]);
	print '''
usage: %s [option]

Options:
''' % basename

## Entry point.
#
#  Deals with options and redirects to proper function.
def main():
	try:
		opts, argv = getopt.getopt(
			sys.argv[1:],
			"hv",
			["help", "verbose"])
	except getopt.GetoptError, err:
		# print help information and exit:
		print str(err) # will print something like "option -a not recognized"
		usage()
		sys.exit(2)

	for o, a in opts:
		if o in ("-h", "--help"):
			usage()
			sys.exit()
		elif o in ("-v", "--verbose"):
			ch.setLevel(logging.DEBUG)
		else:
			assert False, "unhandled option"

	page = get_wallpaper_page('%s/en/media/wallpapers/' % GUILD_WARS_URL)
	parse_page(page, '1920x1080')

if __name__ == "__main__":
	main()
