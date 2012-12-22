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

## Main logger
#
#  There are two loggers:
#    1. A file logger starting a WARNING level
#    2. A console logger starting a DEBUG level
logger = logging.getLogger('log-parser')
logger.setLevel(logging.DEBUG)
fh = logging.FileHandler('log-parser.log')
fh.setLevel(logging.WARNING)
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
fh.setFormatter(formatter)
ch.setFormatter(formatter)
logger.addHandler(fh)
logger.addHandler(ch)

## Datetime constants for conversion
epoch_windows = datetime.date(1601, 1, 1)
epoch_unix = datetime.date(1970, 1, 1)
seconds_delta = (epoch_unix - epoch_windows).days * 3600 * 24

## List of stores to study
STORES = [ "0881", "2340", "2347", "2343", "2317" ]
STORES_NAMES = {
	"0881": "Antibes",
	"2317": "La Seyne",
	"2340": "Englos 2",
	"2343": "Vannes",
	"2347": "Frejus"
}

class Session:
	def __init__(self, sid, uid, crashed=False):
		self.sid = sid
		self.uid = uid
		self.crashed = crashed
		self.errors = []
		self.saved = {}
		self.nb_prints = 0
		self.nb_commands = 0

	def append_error(self, error, message):
		self.errors.append("%s - %s" % (error, message))
		#logger.debug("%s - %s" % (error, urllib.unquote(message)))

	def append_saved(self, message):
		#logger.debug("saved project: %s" % message)
		match = re.search(r'[\w]{12}%2f(.*)\.xsq%5d', message)
		if not match:
			logger.error("invalid project name (weird error) %s" % message)
		else:
			name = match.group(1)
			name = re.sub(r'%20', ' ', name)
			name = re.sub(r'%\w\w', '?', name)
			#logger.debug('store: %s saved project: %s' % (self.sid, name))
			if name in self.saved:
				self.saved[name] += 1
			else:
				self.saved[name] = 1

	def add_print(self):
		self.nb_prints += 1

	def add_command(self):
		self.nb_commands += 1

class Store:
	def __init__(self, sid):
		self.sid = sid
		self.name = "Inconnu"
		if self.sid in STORES_NAMES:
			self.name = STORES_NAMES[self.sid]
		self.sessions = []
		self.errors = []
		self.nb_crash = 0
		self.nb_sessions = 0
		self.nb_prints = 0
		self.nb_commands = 0
		self.projects = {}

	def append_session(self, session):
		self.sessions.append(session)
		self.nb_sessions += 1
		if session.crashed:
			self.nb_crash += 1
		self.errors += session.errors
		self.nb_commands += session.nb_commands
		self.projects.update(session.saved)

class SoCoocStep:

	steps = []

	def __init__(self, uid, date):
		self.uid = uid
		self.date = date
		self.step_action = {}

	def add_action_step(self, step):
		if step not in self.step_action:
			self.step_action[step] = 1
			if step not in SoCoocStep.steps:
				SoCoocStep.steps.append(step)
				SoCoocStep.steps = sorted(SoCoocStep.steps)
		else:
			self.step_action[step] += 1


## Function for making unique non-existent file name
#  with saving source file extension.
#
#  Credit goes to Denis Barmenkov:
#  http://code.activestate.com/recipes/577200-make-unique-file-name/
def add_unique_postfix(fn):
    path, name = os.path.split(fn)
    name, ext = os.path.splitext(name)

    make_fn = lambda i: os.path.join(path, '%s_%d%s' % (name, i, ext))

    for i in xrange(1, sys.maxint):
        uni_fn = make_fn(i)
        if not os.path.exists(uni_fn):
            return uni_fn

    return None

## Increase occurence of a key in a dictionary.
def increment_occurence(d, k):
	if k not in d:
		d[k] = 1
	else:
		d[k] += 1

def format_input_dates(date_start, date_end, week):
	if week:
		current_year = datetime.date.today().year
		january_first = datetime.date(current_year, 1, 1)
		monday = january_first
		while calendar.weekday(monday.year, monday.month, monday.day) != 0:
			monday += datetime.timedelta(days=1)
		delta = datetime.timedelta(days=7)
		start = monday + (week - 1) * delta
		end = start + delta - datetime.timedelta(days=1)
	else:
		try:
			s = datetime.datetime.strptime(date_start, "%Y-%m-%d")
			d = datetime.datetime.strptime(date_end, "%Y-%m-%d")
			start = s.date()
			end = d.date()
		except ValueError, e:
			logger.error("invalid date or format (%s)" % str(e))
			sys.exit(2)
	return (start, end)

def get_log_files(from_date, to_date):
	path = os.path.join(os.curdir, 'LogAnalysis', 'prod')
	logger.info('parsing log files in: %s' % path)
	delta = to_date - from_date
	files = []
	for i in range(delta.days + 1):
		cur_date = from_date + datetime.timedelta(days=i)
		f = os.path.join(path, 'SQ.CM.Server.exe_Client_%s' %
			cur_date.isoformat())
		if not os.path.exists(f):
			logger.warning("%s does not exist" % f)
			continue
		files.append(f)
	return files

## Converts a Windows FILEFORMAT date to a Unix epoch date
def windowsdate_to_date(date):
	fileformat = '%s%s' % (date[8:], date[0:8])
	seconds = long(fileformat, 16) / 10000000
	epoch_seconds = seconds - seconds_delta
	return datetime.date.fromtimestamp(epoch_seconds)

# XXX We could do a better job than parsing all xml files.
# Best way to improve is to convert timestamp filenames to dates
# and parse only xml files within entry dates.
# DONE !
def parse_error_reports(path, session_store, start, end):
	if not os.path.exists(path):
		logger.error("%s does not exist" % path)
		sys.exit(2)
	logger.info("parsing error reports in: %s" % path)
	entries = os.listdir(path)
	nb_entries = len(entries)
	pat_uid = re.compile(r"id='([\w-]+)'")
	previous_percentage = 0.0
	for n, e in enumerate(entries):
		percentage = n * 100 / nb_entries
		if percentage % 10 == 0.0 and percentage != previous_percentage:
			logger.info("error reports progress: %0.0f%%" % percentage)
			previous_percentage = percentage
		filename = os.path.join(path, e)
		name, ext = os.path.splitext(filename)
		if not os.path.isfile(filename) or ext.lower() != ".xml":
			continue
		try:
			basename = os.path.basename(name)
			fileformat = '%s%s' % (basename[8:], basename[0:8])
			seconds = long(fileformat, 16) / 10000000
			epoch_seconds = seconds - seconds_delta
			date = datetime.date.fromtimestamp(epoch_seconds)
			if date < start or date > end:
				logger.debug('skipping: %s (%s)' % (e, date.isoformat()))
				continue
		except ValueError:
			continue
		#logger.info("parsing error report: %s" % filename)
		i = 0
		for l in open(filename):
			i += 1
			match = pat_uid.search(l)
			if match:
				uid = match.group(1)
				#logger.debug('found uid: %s at line: %d' % (uid, i))
				if uid not in session_store:
					#logger.debug('uid: %s does not belong to any store' % uid)
					pass
				else:
					session = session_store[uid]
					session.crashed = True
					logger.info('session: %s (%s) crashed: %s (%s)' %
						(uid, session.sid, e, date.isoformat()))
				break
	logger.info("finished parsing error reports")

def parse_socooc_logs(files):
	# Unique session ID
	pat_uid = re.compile(r'\w{8}-\w{4}-\w{4}-\w{4}-\w{12}')
	sessions_of_interest = set()
	lines_out = []
	for f in files:
		logger.info('parsing: %s' % f)
		i = 0
		for l in open(f, 'r'):
			i += 1
			splits = re.split(r',', l)
			if len(splits) != 7:
				logger.warning('invalid log at line: %s' % i)
				continue
			typ = splits[0]
			app = splits[3]
			uid = splits[4]
			mes = splits[6]

			# Session start
			if uid not in sessions_of_interest:
				if typ == "info" and splits[5] == "session":
					if app == 'socooc':
						sessions_of_interest.add(uid)
					continue

			if uid not in sessions_of_interest:
				continue

			lo = l.replace('%20', ' ')
			lo = lo.replace('%2f', '/')
			lo = lo.replace('%5b', '[')
			lo = lo.replace('%5d', ']')
			lo = lo.replace('%3a', ':')
			lo = lo.replace('%0a', ' ')
			lo = lo.replace('%23', '#')
			lines_out.append(lo)

	filepath = os.path.join(os.curdir, 'socooc.log')
	file_out = open(filepath, 'wt')
	file_out.writelines(lines_out)
	return filepath

def parse_log_files(files):
	# Store ID
	pat_sid = re.compile(r'identification%20%5b(\d{4})%5d%20')
	# Unique session ID
	pat_uid = re.compile(r'\w{8}-\w{4}-\w{4}-\w{4}-\w{12}')
	# Print
	pat_pri = re.compile(r'Billing.*PrintButton')
	# Command (fr: devis)
	pat_com = re.compile(r'%2fCommande%5d')
	store_sessions = { k: [] for k in STORES }
	session_store = {}
	sessions_of_interest = set()
	for f in files:
		logger.info('parsing: %s' % f)
		i = 0
		for l in open(f, 'r'):
			i += 1
			splits = re.split(r',', l)
			if len(splits) != 7:
				logger.warning('invalid log at line: %s' % i)
				continue
			typ = splits[0]
			uid = splits[4]
			mes = splits[6]

			# Session start
			if uid not in sessions_of_interest:
				if typ == "info" and splits[5] == "session":
					if mes.find('%5bProduction_Castorama') != -1:
						sessions_of_interest.add(uid)
					continue

			if uid not in sessions_of_interest:
				continue

			# Is this a new 'identification pattern'?
			mat_sid = pat_sid.search(mes)
			if mat_sid:
				sid = mat_sid.group(1)
				if sid not in STORES:
					# This session ID is not of interest to us
					sessions_of_interest.remove(uid)
					continue
				if not pat_uid.match(uid):
					logger.error('invalid session id: %s (%d)' % (uid, i))
				if sid == "0881":
					logger.debug('store: %s - session: %s (%d)' %
						(sid, uid, i))
				store_sessions[sid].append(uid)
				if uid in session_store:
					logger.error('session id: %s already created before' % uid)
					sys.exit(2)
				session = Session(sid, uid)
				session_store[uid] = session
			elif uid not in session_store:
				continue

			# At this point it can only be a session we know
			if typ == "error":
				session_store[uid].append_error(splits[5], mes)
			elif typ == "info":
				ses = session_store[uid]
				if mes.startswith("\"Save"):
					ses.append_saved(mes)
				elif pat_pri.search(mes):
					ses.add_print()
				elif pat_com.search(mes):
					ses.add_command()

	#for (k, v) in store_sessions.items():
	#	logger.debug('%s: %s' % (k, v))
	return (store_sessions, session_store)

def write_results(session_store, date_from, date_to):
	try:
		from xlwt import Workbook
		from xlwt import Style
		from xlwt import easyxf
	except ImportError:
		logger.error('unable to find python package xlwt for Excel files')
		sys.exit(2)

	path = os.path.join(os.curdir, 'LogAnalysis', 'results')
	if not os.path.exists(path):
		os.makedirs(path)
	name = '%s-%s-%s.xls' % (
		'Castorama', date_from.isoformat(), date_to.isoformat())
	logger.info("writing excel file: %s" % name)

	stores = { k: Store(k) for k in STORES }
	for k, v in session_store.items():
		stores[v.sid].append_session(v)

	for k in sorted(stores.iterkeys()):
		v = stores[k]
		for s in v.sessions:
			logger.debug('%s - %s' % (k, s.uid))
			# XXX Do we count multiple prints per sessions ? yes !
			if 1:
				v.nb_prints += s.nb_prints
			else:
				if s.nb_prints:
					v.nb_prints += 1
		t = "store: %s has: %d sessions - %d crashes - %d prints - %d commands"
		logger.debug(t % (k, v.nb_sessions, v.nb_crash,
			v.nb_prints, v.nb_commands))

	style_head = easyxf(
		'font: \
			bold on, color white; \
		align: \
			horiz center, vert center; \
		pattern: \
			pattern solid, back-color light_blue, fore-color light_blue;')
	style_cell = easyxf(
		'border: \
			bottom medium, \
			bottom-colour light_blue;')
	wb = Workbook(encoding="utf8")
	ws0 = wb.add_sheet('Synthese')
	ws1 = wb.add_sheet('Erreurs')
	ws2 = wb.add_sheet('Projets')

	for col, text in enumerate(["Magasin", "Nom", "Sessions",
		"Messages d'erreur", "Erreurs applicatives", "Passage de commande",
		"Impression devis", "Projets uniques", "Crash"]):
		ws0.write(0, col, text, style_head)
	for col, text in enumerate(["Magasin", "Message"]):
		ws1.write(0, col, text, style_head)
	for col, text in enumerate(["Magasin", "Sauvegardes", "Projet"]):
		ws2.write(0, col, text, style_head)

	row_syn = 1
	row_err = 1
	row_pro = 1
	for k in sorted(stores.iterkeys()):
		store = stores[k]
		ws0.write(row_syn, 0, store.sid, style_cell)
		ws0.write(row_syn, 1, store.name, style_cell)
		ws0.write(row_syn, 2, store.nb_sessions, style_cell)
		ws0.write(row_syn, 3, len(store.errors), style_cell)
		ws0.write(row_syn, 4, 0, style_cell)
		ws0.write(row_syn, 5, store.nb_commands, style_cell)
		ws0.write(row_syn, 6, store.nb_prints, style_cell)
		ws0.write(row_syn, 7, len(store.projects.keys()), style_cell)
		ws0.write(row_syn, 8, store.nb_crash, style_cell)
		row_syn += 1

		# Error messages
		for e in store.errors:
			ws1.write(row_err, 0, store.sid, style_cell)
			e = re.sub(r'%20', ' ', e)
			e = re.sub(r'%\w\w', '?', e)
			ws1.write(row_err, 1, e, style_cell)
			row_err += 1

		# Projects
		for p, o in store.projects.items():
			ws2.write(row_pro, 0, store.sid, style_cell)
			ws2.write(row_pro, 1, o, style_cell)
			ws2.write(row_pro, 2, p, style_cell)
			row_pro += 1

	filepath = os.path.join(path, name)
	wb.save(filepath)
	try:
		storagepath = '/root/serveur01/Guillaume/Castorama/LogParser/'
		shutil.copy(filepath, storagepath)
	except IOError:
		logger.warning('could not copy result file to: %s', storagepath)

def get_socooc_step(session_steps, uid, date):
	if uid not in session_steps:
		session_steps[uid] = SoCoocStep(uid, date)
	return session_steps[uid]

def write_socooc_results(session_steps, session_filter, date_from, date_to):
	try:
		from xlwt import Workbook
		from xlwt import Style
		from xlwt import easyxf
	except ImportError:
		logger.error('unable to find python package xlwt for Excel files')
		sys.exit(2)

	path = os.path.join(os.curdir, 'LogAnalysis', 'results')
	if not os.path.exists(path):
		os.makedirs(path)
	name = '%s-%s-%s.xls' % (
		'SoCooc', date_from.isoformat(), date_to.isoformat())
	logger.info("writing excel file: %s" % name)

	style_head1 = easyxf(
		'font: \
			bold on, color white; \
		align: \
			horiz center, vert center; \
		pattern: \
			pattern solid, back-color light_blue, fore-color light_blue;')
	style_head2 = easyxf(
		'font: \
			bold on, color white; \
		align: \
			horiz center, vert center; \
		pattern: \
			pattern solid, back-color gray25, fore-color gray25;')
	style_cell = easyxf(
		'border: \
			bottom medium, \
			bottom-colour light_blue;')
	wb = Workbook(encoding="utf8")
	ws0 = wb.add_sheet('Sessions')
	ws1 = wb.add_sheet('Synthese')
	for col, text in enumerate(["Date", "Session"]):
		ws0.write(0, col, text, style_head1)

	ws1.write(0, 0, "Nombre de sessions", style_head1)
	for col, s in enumerate(SoCoocStep.steps):
		ws0.write(0, 2 + col, "Actions Etape %d" % s, style_head1)
		ws1.write(0, 1 + col, "Pourcentage Etape %d" % s, style_head1)

	new_project_sessions = 0
	unique_steps = {}
	for s in SoCoocStep.steps:
		unique_steps[s] = 0
	unique_step1 = 0
	unique_step2 = 0
	unique_step10 = 0
	unique_step11 = 0
	unique_step12 = 0
	unique_finished = 0

	row_syn = 0
	for uid, steps in sorted(session_steps.items(), key=lambda (k, v): v.date):
		if 1 not in steps.step_action or steps.step_action[1] == 0:
			continue
		row_syn += 1
		new_project_sessions += 1
		ws0.write(row_syn, 0, steps.date.isoformat(), style_cell)
		ws0.write(row_syn, 1, uid, style_cell)

		for i, s in enumerate(SoCoocStep.steps):
			if s in steps.step_action:
				action = steps.step_action[s]
				unique_steps[s] += 1
			else:
				action = 0
			ws0.write(row_syn, 2 + i, action, style_cell)

	logger.debug("total number of sessions: %d" % new_project_sessions)
	ws1.write(1, 0, new_project_sessions, style_head1)
	for i, s in enumerate(SoCoocStep.steps):
		logger.debug('step: %d: %d' % (s, unique_steps[s]))
		ws1.write(1, 1 + i,
			unique_steps[s] * 100 / new_project_sessions, style_cell)

	filepath = os.path.join(path, name)
	wb.save(filepath)
	try:
		storagepath = '/root/serveur01/Guillaume/Castorama/LogParser/'
		shutil.copy(filepath, storagepath)
	except IOError:
		logger.warning('could not copy result file to: %s', storagepath)

def analyse_socooc_logfile(logfile):
	pat_final_save = re.compile(r'/finalizationQuotation/saveproject]"')
	pat_login_new = re.compile(r'/LoginPanel/.*/Newaccount]"')
	pat_login_ide = re.compile(r'/LoginPanel/.*/Identifie]"')
	pat_newaccount_validate = re.compile(r'/NewAccountPanel/.*/valider]"')
	pat_newaccount_saved = re.compile(r'^"SaveProject')
	pat_roomshape = re.compile(r'/roomShape/')
	pat_kitchenambiance = re.compile(r'/kitchenAmbience/')
	pat_roomdetailedplan = re.compile(r'/roomDetailedPlan/')
	i = 0
	session_steps = {}
	sessions_filter = set()

	for l in open(logfile):
		i += 1
		splits = re.split(r',', l)
		typ = splits[0]
		tim = splits[1]
		uid = splits[4]
		mes = splits[6]
		date = windowsdate_to_date(tim)
		if uid in sessions_filter:
			continue
		step = get_socooc_step(session_steps, uid, date)
		if pat_roomshape.search(mes):
			step.add_action_step(1)
		elif pat_roomdetailedplan.search(mes):
			step.add_action_step(2)
		elif pat_kitchenambiance.search(mes):
			step.add_action_step(3)
		elif pat_final_save.search(mes):
			step.add_action_step(10)
		# Remove regular 'login' sessions
		elif pat_login_ide.search(mes):
			sessions_filter.add(uid)
		elif pat_login_new.search(mes):
			step.add_action_step(11)
		elif pat_newaccount_validate.search(mes):
			step.add_action_step(12)
		elif pat_newaccount_saved.search(mes):
			step.add_action_step(13)

	# Remove filtered sessions
	for s in sessions_filter:
		if s in session_steps:
			logger.debug('removing session: %s because user is known' % s)
			del session_steps[s]

	return (session_steps, sessions_filter)

## Print usage of the package.
def usage():
	basename = os.path.basename(sys.argv[0]);
	print '''
usage: %s [option]
This program is based on the following hierarchy:
  LogAnalysis
    prod
  CM
    Error Reports

It will parse the logs in LogAnalysis/prod and the XML files in
CM/Error\ Reports.

Options:
  -v
  --verbose
    Verbose mode, print debugging messages.
  --week
    Week of current year. Use --from-date and --to-date for better granularity.
    A week starts from a Monday and ends on the following Sunday.
    Week 1 in 2012 is: 2012-01-02 to 2012-01-08.
  --from-date
    Parse logs from specified date. Use format: YYYY-MM-DD
  --to-date
    Parse logs to specified date. Use format: YYYY-MM-DD
''' % basename

## Entry point.
#
#  Deals with options and redirects to proper function.
def main():
	try:
		opts, argv = getopt.getopt(
			sys.argv[1:],
			"hvl:",
			["help", "from-date=", "to-date=", "week=", "verbose", "socooc"])
	except getopt.GetoptError, err:
		# print help information and exit:
		print str(err) # will print something like "option -a not recognized"
		usage()
		sys.exit(2)

	system = platform.system()

	date_start = None
	date_end = None
	week = 0
	socooc = False
	socooc_logfile = None

	for o, a in opts:
		if o in ("-h", "--help"):
			usage()
			sys.exit()
		elif o in ("-v", "--verbose"):
			ch.setLevel(logging.DEBUG)
		elif o in ("--week"):
			week = int(a)
		elif o in ("--from-date"):
			date_start = a
		elif o in ("--to-date"):
			date_end = a
		elif o in ("--socooc"):
			socooc = True
		elif o in ("-l"):
			socooc_logfile = a
		else:
			assert False, "unhandled option"

	if not week and (not date_end or not date_start):
		logger.error("invalid usage, specify dates or a week")
		usage()
		sys.exit(2)

	# Time measurements
	t0 = time.time()

	# Format input dates
	start, end = format_input_dates(date_start, date_end, week)
	files = get_log_files(start, end)
	if socooc:
		if not socooc_logfile:
			socooc_logfile = parse_socooc_logs(files)
		session_steps, session_filter = analyse_socooc_logfile(socooc_logfile)
		write_socooc_results(session_steps, session_filter, start, end)
	else:
		store_sessions, session_store = parse_log_files(files)
		parse_error_reports(
			os.path.join(os.curdir, 'CM', 'Error Reports'),
			session_store, start, end)
		write_results(session_store, start, end)

	te = time.time() - t0
	logger.info("total time to complete operations: %.2f s" % (te))

if __name__ == "__main__":
	main()
