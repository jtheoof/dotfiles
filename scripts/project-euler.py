#!/usr/bin/python

import getopt
import math
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
	print 19 * 17 * 13 * 11 * 7 * 5 * 3**2 * 2**4

"""
	Brut forcing it.
"""
def problem_6():
	s1 = sum(x ** 2 for x in range(1, 101))
	s2 = sum(x for x in range(1, 101)) ** 2
	print s2 - s1

"""
	Listing prime numbers up to sqrt(n) each time.
"""
def problem_7():
	primes = [2]
	n = 3
	while (len(primes) < 1000000):
		root = math.floor(n ** 0.5)
		for p in primes:
			if p > root:
				primes.append(n)
				break
			if n % p == 0:
				break
		n += 2
	print primes[-1]

"""
	Using string as iterator.

	I didn't use list comprehensions but I enjoy
	Niten solution:

	<code>
		from string import whitespace
		from operator import mul

		data = open('/tmp/data') # Number pasted to file.
		nos = [int(c) for line in data for c in line if c not in whitespace]
		print max([reduce(mul, nos[i:i+5]) for i in range(len(nos)-5)])
	</code>
"""
def problem_8():
	digits  = "73167176531330624919225119674426574742355349194934"
	digits += "96983520312774506326239578318016984801869478851843"
	digits += "85861560789112949495459501737958331952853208805511"
	digits += "12540698747158523863050715693290963295227443043557"
	digits += "66896648950445244523161731856403098711121722383113"
	digits += "62229893423380308135336276614282806444486645238749"
	digits += "30358907296290491560440772390713810515859307960866"
	digits += "70172427121883998797908792274921901699720888093776"
	digits += "65727333001053367881220235421809751254540594752243"
	digits += "52584907711670556013604839586446706324415722155397"
	digits += "53697817977846174064955149290862569321978468622482"
	digits += "83972241375657056057490261407972968652414535100474"
	digits += "82166370484403199890008895243450658541227588666881"
	digits += "16427171479924442928230863465674813919123162824586"
	digits += "17866458359124566529476545682848912883142607690042"
	digits += "24219022671055626321111109370544217506941658960408"
	digits += "07198403850962455444362981230987879927244284909188"
	digits += "84580156166097919133875499200524063689912560717606"
	digits += "05886116467109405077541002256983155200055935729725"
	digits += "71636269561882670428252483600823257530420752963450"

	result = 0
	for i in range(len(digits)-5):
		string = digits[i:i+5]
		product = 1
		for s in string:
			product *= int(s)
		if product > result:
			result = product
	print result


"""
	Brut force.
"""
def problem_9():
	for a in range(1, 500):
		for b in range(a, 500):
			c = math.sqrt(a**2 + b**2)
			f, i = math.modf(c)
			if f == 0.0 and a + b + c == 1000:
				print '%d + %d + %d = 1000' % (a, b, c)
				print int(a * b * c)
				return

"""
	Using usual sqrt(n) upper limit for each integer.
"""
def problem_10a():
	primes = [2]
	n = 3
	total = 2
	while (n < 2000000):
		root = math.floor(n ** 0.5)
		for p in primes:
			if p > root:
				primes.append(n)
				total += n
				break
			if n % p == 0:
				break
		n += 2
	print total

"""
	Using Eratothene sieve algorithm with O(nlog(log(n))) complexity.
	Much faster then previous approach.
"""
def problem_10b():
	limit = 2000000
	# I don't think python allows index starting at 2 so I start from 0
	numbers = [True for i in range(0, limit)]
	# Killing 0 and 1
	numbers[0] = numbers[1] = False
	for i in range(2, limit/2):
		p = numbers[i]
		if p:
			k = 2
			j = k * i
			while (j < limit):
				numbers[j] = False
				k += 1
				j = k * i
	print sum(i for i, v in enumerate(numbers) if v is True)

def usage():
	basename = os.path.basename(sys.argv[0]);
	print '''
usage: %s [option] filename
Options:
	-p --problem Print of solution of problem p
	-v --version Run a specific version of a problem
''' % basename

def main():
	try:
		opts, argv = getopt.getopt(sys.argv[1:],
				"hp:v:",
				["help", "problem=", "version="])
	except getopt.GetoptError, err:
		# print help information and exit:
		print str(err) # will print something like "option -a not recognized"
		usage()
		sys.exit(2)
	problem = 0
	version = ''

	for o, a in opts:
		if o in ("-h", "--help"):
			usage()
			sys.exit()
		elif o in ("-p", "--problem"):
			problem = int(a)
		elif o in ("-v", "--version"):
			version = a
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
	elif problem == 6:
		problem_6()
	elif problem == 7:
		problem_7()
	elif problem == 8:
		problem_8()
	elif problem == 9:
		problem_9()
	elif problem == 10:
		if version == 'a':
			problem_10a()
		else:
			problem_10b()
	else:
		print 'Unkown problem: %d' % problem

if __name__ == "__main__":
	main()
