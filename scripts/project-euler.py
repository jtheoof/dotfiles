#!/usr/bin/python

import getopt
import os
import re
import sys


def problem_1():
	total = sum(x for x in range(1000) if x % 3 == 0 or x % 5 == 0)
	print total

def usage():
	basename = os.path.basename(sys.argv[0]);
	print '''
usage: %s [option] filename
Options:
  -c --cleanup
	Cleanup input file, removing unmatched lines
	sorting it by time and printing results to standard output.
	This option overrides -t -s and -n
  -t --thread
    Show only this thread id (number)
  -s --severity
    Show logs with given severity (number)
  -n --no-sort
	Assume the file is already sorted by time
  -q --quiet
	Don't show standard errors
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

	if problem == 1:
		problem_1()
	else:
		print 'Unkown problem: %d' % problem

if __name__ == "__main__":
	main()
