#!/usr/bin/python

import getopt
import os
import re
import sys


"""
	Hard to be more condensed than that.
"""
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

def problem_3():
	n = 600851475143;
	p = 2
	while n > 1:
		if n % p == 0:
			n = n / p
		else:
			p += 1
	print p

"""
	Could check for less numbers.

	p = abccba
	...
	p = 11(9091a + 910b + 100c)

	Also I don't need to store the palindromes in an
	array but I find it fun.
"""
def problem_4():
	palindromes = []
	for i in range(100, 1000):
		for j in range(100, 1000):
			p = i * j
			s = str(p)
			palindrome = True
			k = 0
			l = len(s)
			while k <= l / 2:
				if s[k] != s[l - 1 - k]:
					palindrome = False
					break
				k += 1
			if palindrome:
				palindromes.append(p)
	print max(palindromes)

"""
	This one is easy to solve mathematically.

	I just decomposed each integer from 1 to 20 in primes numbers
	and used the biggest power of each prime number.
	Multiplying them together will lead the minimum number divisble by
	n, n belonging to [1, 20].
"""
def problem_5():
	print 19 * 17 * 13 * 11 * 7 * 5 * 3 ^ 2 * 2 ^ 4

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
	elif problem == 3:
		problem_3()
	elif problem == 4:
		problem_4()
	elif problem == 5:
		problem_5()
	else:
		print 'Unkown problem: %d' % problem

if __name__ == "__main__":
	main()
