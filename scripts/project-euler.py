#!/usr/bin/python

import getopt
import os
import re
import sys


def problem_1():
	total = sum(x for x in range(1000) if x % 3 == 0 or x % 5 == 0)
	print total

def problem_2():
	un2 = 1
	un1 = 2
	un  = un1
	total = 2
	while 1:
		un  = un2 + un1
		if un >= 4000000:
			break
		if un % 2 == 0:
			total += un
		un2 = un1
		un1 = un
	print total

def usage():
	basename = os.path.basename(sys.argv[0]);
	print '''
usage: %s [option] filename
Options:
	-p --problem Print of solution of problem p
''' % basename

def main():
	try:
		opts, argv = getopt.getopt(sys.argv[1:],
				"hp:",
				["help", "problem="])
	except getopt.GetoptError, err:
		# print help information and exit:
		print str(err) # will print something like "option -a not recognized"
		usage()
		sys.exit(2)
	problem = 0
	for o, a in opts:
		if o in ("-h", "--help"):
			usage()
			sys.exit()
		elif o in ("-p", "--problem"):
			problem = int(a)
		else:
			assert False, "unhandled option"

	if problem == 0:
		usage()
		sys.exit(2)
	if problem == 1:
		problem_1()
	elif problem == 2:
		problem_2()
	else:
		print 'Unkown problem: %d' % problem

if __name__ == "__main__":
	main()
