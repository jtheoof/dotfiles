#!/usr/bin/python

## @package catalog-manager
#  Provides general functions to parse SQ3 files
#  and generate SQL code.
#
#  Can manage both 3D and MATERIALS (with TEXTURES).

import csv
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
#    2. A console logger starting a DEUBG level
logger = logging.getLogger('catalog-manager')
logger.setLevel(logging.DEBUG)
fh = logging.FileHandler('catalog-manager.log')
fh.setLevel(logging.WARNING)
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
fh.setFormatter(formatter)
ch.setFormatter(formatter)
logger.addHandler(fh)
logger.addHandler(ch)

## Deprecated
KIND_FURNITURE = 1
KIND_MATERIAL = 2
KIND_FRAME = 3

## Catalogs
CATALOGS = {
	'Generique': 1,
	'Fly': 2,
	'Castorama': 3,
	'Made': 4,
	'Decoondemand': 5
}

CATALOG_GENERIQUE = 1

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

## Parse the CSV file used to keep track of ids in a catalogue.
#
#  The ids are used in order to avoid duplicates and make proper
#  copies of SQ3 for SQCM.
def parse_csv(filename):
	files = {}
	try:
		read = csv.reader(open(filename, "rb"))
	except IOError:
		return files
	ids_occ = {}
	logger.info("parsing: %s", filename)
	for r in read:
		iden = r[0]
		increment_occurence(ids_occ, iden)
		if iden in files:
			pass
		else:
			files[iden] = {
				'path': ''
			}
	for k, v in [(k, v) for k, v in ids_occ.items() if v > 1]:
		logger.warning('%s found %d times in csv' % (k, v))
	return files

## Parse a 'materials' file (usually Style.xls)
#  
#  Fills in a dictionary where the key is the id of the material.
#  The value is another dictionary containing 'cat_name_fr' and 'texture'.
#  Ex:
#  {
#    'sketch_in_the_grass_06': {
#      'cat_name_fr': 'Papier peint a motifs',
#      'texture': 'in_the_grass_06'
#    }
#  }
def parse_material_xls(xls, textures):
	import xlrd
	logger.info("parsing xml file: %s" % xls)
	try:
		book = xlrd.open_workbook(xls, formatting_info=True)
	except IOError:
		logger.error("unable to open: %s" % xls)
		sys.exit(2)

	materials = {}
	for i in range(book.nsheets):
		sheet = book.sheet_by_index(i)

		# Invalid sheet
		if sheet.nrows < 5 or sheet.ncols < 17:
			continue

		for row in range(4, sheet.nrows):
			ide = unicode(sheet.cell(row, 0).value).strip()
			lib = string.capwords(unicode(sheet.cell(row, 3).value))
			typ = unicode(sheet.cell(row, 5).value)
			cat = unicode(sheet.cell(row, 6).value)
			tex = unicode(sheet.cell(row, 15).value).strip()
			tep = "" # Texture path
			if not ide:
				continue
			logger.debug("material: %s - texture: %s" % (ide, tex))
			if len(typ):
				typ = typ[0].upper() + typ[1:]
			if tex:
				if tex not in textures:
					logger.error("unable to find texture: %s for: %s" %
						(tex, ide))
					continue
				else:
					tep = textures[tex]['path']
			if ide in materials:
				logger.error("duplicate key: %s" % ide)
				continue

			buf = {
				'cat_name_fr': lib if lib != '' else None,
				'texture': tep
			}
			materials[ide] = buf
	return materials

## Find all textures (usually jpg files) in CG/TEXTURES/
#
#  Fills in a dictionary of the basename (without the extension) with a path.
#  Ex:
#  {
#    'in_the_grass_06': {
#      'path': './CG/TEXTURES/garden/in_the_grass_06.jpg'
#    }
#  }
def find_textures(directory, extensions=["jpg"]):
	logger.info('looking for textures in %s' % os.path.abspath(directory))
	textures = {}
	for root, dirnames, filenames in os.walk(directory):
		for f in filenames:
			n, e = os.path.splitext(f)
			if e[1:].lower() in extensions:
				path = os.path.join(root, f)
				if n in textures:
					logger.error("texture: %s already found here: %s" %
						(path, textures[n]['path']))
					sys.exit(2)
				else:
					textures[n] = {
						'path': path
					}
	return textures

## Find geometry files (usually sq3 files) in CG/3D/CATALOG
#
#  Fills in a dictionary based on catalog_geometryid.
#  Ex:
#  {
#    'generic_archmodels_05': {
#      'sq3': 'archmodels_05.SQ3',
#      'path': './CG/3D/GENERIQUE/.../Beds/archmodels_05/archmodels05.SQ3',
#      'type': 'Beds',
#    }
#  }
def find_geometry(directory, catalog, extension="sq3",
		previous_files={}, only_new=True):
	logger.info('looking for files in %s' % os.path.abspath(directory))
	catalog = catalog.lower()
	ids = {}
	old = {}
	ids_occ = {}
	ids_rem = previous_files.copy() # this dict should be empty at the end
	sep = os.sep if os.sep != '\\' else '\\\\'
	for root, dirnames, filenames in os.walk(directory):
		for f in filenames:
			n, e = os.path.splitext(f)
			if e[1:].lower() == extension:
				tmp, bas = os.path.split(root)
				ide = '%s_%s' % (catalog, bas)
				tmp2, typ = os.path.split(tmp)
				increment_occurence(ids_occ, ide)
				new = {
					'sq3': f,
					'path': '%s%s%s' % (root, os.sep, f),
					'type': typ,
				}
				if ide in previous_files:
					# Remove key
					try:
						ids_rem.pop(ide)
					except:
						pass
					if only_new:
						continue
					else:
						old[ide] = new
				else:
					ids[ide] = new

	if len(ids_rem):
		for k, v in ids_rem.items():
			logger.error('id: %s was removed be careful' % k)
		sys.exit(2)

	for k, v in [(k, v) for k, v in ids_occ.items() if v > 1]:
		logger.warning('id: %s found %d times' % (k, v))
		if k in ids:
			ids.pop(k)
	return ids, old

## Load a Dictionary containing unique names for geometry.
def load_names():
	dictionary = os.path.join(os.curdir, "NAMES", "Dictionary.txt")
	names = open(dictionary, "rt")
	return [ l.strip() for l in names.readlines() ]

## Save the dictionary, removing the names that were used
#  in the process of generating the CSV file.
def save_names(names):
	dictionary = os.path.join(os.curdir, "NAMES", "Dictionary.txt")
	new_names = open(dictionary, "wt")
	new_names.writelines([ '%s\r\n' % n for n in names ])

## Generate CSV files.
#
#  This function will generate 3 CSV files:
#    One for general geometries to keep track of all ids.
#    One for new goemetries added to make it easier for import in Excel.
#      It's naming convention is: catalog_geometry_X.csv where X is unique.
#    One for new categories added when new geometry is found.
def generate_csv(files, output_name, random_names=True):
	names = load_names()
	pattern = os.sep if os.sep != '\\' else '\\\\'
	lines = []
	categories = set()
	xl_path = os.path.join(os.curdir, "EXCEL")
	for k, v in files.items():
		if len(names) == 0:
			logger.error("no more names in dictionary, please insert new ones")
			sys.exit(2)
		r = random.randint(0, len(names) - 1)
		f = v['path']
		t = v['type']
		splits = re.split(pattern, f)
		splits = splits[3:] # Remove './CG/3D/GENERIQUE/'
		cat = os.sep.join(splits[0:-2])
		if random_names:
			nam = names.pop(r)
		else:
			nam = ""
		if cat not in categories:
			categories.add(cat)
		line = [k, k + ".SQ3", v['sq3'], nam, t] # [ID, File.sq3, Type]
		lines.append(line)
	lines_s = sorted(lines, key=lambda x: x[0])
	categories_s = sorted(categories)
	save_names(names)

	geometry_name = '%s_geometry.csv' % output_name.lower()
	filename = os.path.join(xl_path, geometry_name)
	logger.info("updating: %s" % filename)
	output = open(filename, mode='ab')
	writer = csv.writer(output)
	for l in lines_s:
		writer.writerow(l)

	filename = os.path.join(xl_path, '%s_geometry.csv' % output_name.lower())
	geometry_unique = add_unique_postfix(filename)
	logger.info("generating: %s" % geometry_unique)
	output = open(geometry_unique, mode='wb')
	writer = csv.writer(output)
	for l in lines_s:
		writer.writerow(l)

	filename = os.path.join(xl_path, '%s_category.csv' % output_name.lower())
	category_name = add_unique_postfix(filename)
	logger.info("generating: %s" % category_name)
	catego = open(category_name, 'wb')
	writer = csv.writer(catego)
	for c in categories_s:
		splits = re.split(pattern, c)
		writer.writerow(splits)

## Retrieve metadata of a given filename.
def get_file_metadata(filename):
	stat_info = os.stat(filename)
	return stat_info

## Find out if a file needs to be updated.
#
#  If origin is newer than copy, this function will return true.
#  Otherwise it will return false.
def need_update(origin, copy):
	ori_info = get_file_metadata(origin)
	cpy_info = get_file_metadata(copy)
	return cpy_info.st_mtime < ori_info.st_mtime

## Copy a file from 'fr' to 'to' if it needs an update.
def copy_file(ide, fr, to):
	try:
		if os.path.exists(to):
			if need_update(fr, to):
				logger.warning("updating file: %s" % to)
				shutil.copy(fr, to)
		else:
			shutil.copy(fr, to)
	except:
		logger.error("unable to copy: %s for id: %s" % (fr, ide))

## Flaten all textures from a material catalog for easier SQCM management.
def tex_to_sqcm(materials, catalog):
	path_out = os.path.join(os.curdir, "CG", "MATERIALS")
	path_out = os.path.join(path_out, "%s_SQCM" % catalog.split("_")[0])
	logger.info("generating sqcm tree to: %s_SQCM" % path_out)
	if not os.path.exists(path_out):
		logger.info("creating directory: %s" % path_out)
		os.makedirs(path_out)
	for k, v in materials.items():
		texture = v['texture']
		if not texture:
			continue
		filename = os.path.basename(texture)
		logger.debug("checking to copy: %s" % filename)
		tex_sqcm = os.path.join(path_out, filename)

		# Update texture if needed
		copy_file(k, texture, tex_sqcm)

## Flaten all geometries from a 3D catalog for easier SQCM management.
#
#  It will also look for thumbnails and copy them if needed.
def sq3_to_sqcm(ids, catalog):
	logger.info("generating sqcm tree to: %s_SQCM" % catalog)
	pattern = os.sep if os.sep != '\\' else '\\\\'
	for k, v in ids.items():
		sq3 = v['path']
		path, filename = os.path.split(sq3)
		spl = re.split(pattern, sq3)
		out = spl[3] + "_SQCM"
		las = spl[-2]
		typ = v['type']
		thu = os.path.join(path, "%s_v77.jpg" % las)
		big = os.path.join(path, "%s_v0001.jpg" % las)
		pat = os.path.join(os.curdir, "CG", "3D", out)
		if not os.path.exists(pat):
			logger.info("creating directory: %s" % pat)
			os.makedirs(pat)
		sq3_sqcm = os.path.join(pat, "%s.SQ3" % k)
		thu_sqcm = os.path.join(pat, "%s_v77.jpg" % k)
		big_sqcm = os.path.join(pat, "%s_v512.jpg" % k)

		# Update geometry and thumbnails if needed
		copy_file(k, sq3, sq3_sqcm)
		copy_file(k, thu, thu_sqcm)
		copy_file(k, big, big_sqcm)

## Generate SQL based on a Schema file and Database.xls
def generate_sql(host, user, passw, db):
	import MySQLdb as mysql
	import xlrd
	con = None
	cur = None
	try:
		con = mysql.connect(host, user, passw , db,
			use_unicode=True, charset="utf8")
		cur = con.cursor()
		sql = os.path.join('SQL', 'schema.sql')
		# Insert SQL Schema
		for l in open(sql, 'rt'):
			cur.execute(l)
		xls = os.path.join("EXCEL", "Database.xls")
		book = xlrd.open_workbook(xls, formatting_info=True)

		for i in range(book.nsheets):
			sheet = book.sheet_by_index(i)
			logger.info("processing stylesheet: %s" % sheet.name)
			if sheet.name == "Category":
				for row in range(4, sheet.nrows):
					cate_par_id = cate_cur_id = None
					for col in range(1, sheet.ncols):
						cate_par_id = cate_cur_id
						cat = unicode(sheet.cell(row, col).value).strip()
						if not cat:
							continue
						if col == 1:
							cat = cat.capitalize()
							cur.execute("SELECT id FROM nehome_catalog \
									     WHERE name=%s", cat)
							data = cur.fetchone()
							if not data:
								if cat not in CATALOGS:
									logger.error("unkown catalog: %s" % cat)
									logger.info("update dictionary CATALOGS")
									sys.exit(2)
								id_cat = CATALOGS[cat]
								cur.execute("INSERT INTO nehome_catalog \
										     SET id=%s, name=%s", (id_cat, cat))
								cata_cur_id = id_cat
								logger.debug("created catalogue: %s" % cat)
							else:
								cata_cur_id = int(data[0])
						logger.debug("catalog id: %d" % cata_cur_id)

						# Inserting new category if needed
						cur.execute("SELECT id, id_catalog, name_en, name_fr \
						             FROM nehome_category \
						             WHERE name_en=%s AND id_catalog=%s",
							(cat, cata_cur_id))
						data = cur.fetchone()
						if not data:
							cur.execute("INSERT INTO nehome_category \
									     SET name_en=%s, id_catalog=%s",
								(cat, cata_cur_id))
							cur.execute("SELECT LAST_INSERT_ID()")
							cate_cur_id = int(cur.fetchone()[0])
							logger.debug("created category: %s" % cat)
						else:
							cate_cur_id = int(data[0])

						# Inserting new tree: parent -> child if needed
						if cate_par_id:
							# Can occur when two same categories
							# follow each other
							if cate_par_id == cate_cur_id:
								logger.warning("category: %s is looping" % cat)
								continue
							cur.execute("SELECT * FROM nehome_cat_arbo \
									     WHERE id_cat_parent=%s AND \
									           id_cat_child=%s",
								(cate_par_id, cate_cur_id))
							data = cur.fetchone()
							if not data:
								cur.execute("INSERT INTO nehome_cat_arbo \
									     	 SET id_cat_parent=%s, \
									           	 id_cat_child=%s",
									(cate_par_id, cate_cur_id))
								logger.debug("created arbo: %d -> %d" %
									(cate_par_id, cate_cur_id))

			elif sheet.name == "Geometry":
				cur.execute("INSERT INTO nehome_kind SET \
						     id=%s, name_en=%s, name_fr=%s",
					(1, "Furniture", "Meubles"))
				for row in range(4, sheet.nrows):
					iden = unicode(sheet.cell(row, 1).value).strip()
					geom = unicode(sheet.cell(row, 2).value).strip()
					fsq3 = unicode(sheet.cell(row, 3).value).strip()
					name = unicode(sheet.cell(row, 4).value).strip()
					cate = unicode(sheet.cell(row, 5).value).strip()
					defr = unicode(sheet.cell(row, 7).value).strip()
					deen = unicode(sheet.cell(row, 8).value).strip()
					urlv = unicode(sheet.cell(row, 9).value).strip()
					cata = iden.split("_")[0].capitalize()
					typc = ('%s_%s' % (cata, cate.replace(" ", "_"))).lower()
					id_cata = CATALOGS[cata]
					logger.debug('geometry: %s - %s - %s - %s' %
						(iden, name, cate, cata))

					# Find corresponding catalogue
					cur.execute("SELECT id FROM nehome_catalog \
								 WHERE name=%s", cata)
					data = cur.fetchone()
					if not data:
						logger.error("unable to find catalog: %s" % cata)
						#sys.exit(2)
						continue
					id_cata = int(data[0])

					# Find type if exists
					cur.execute("SELECT id, name FROM nehome_type \
							     WHERE name=%s", typc)
					data = cur.fetchone()
					if not data:
						# Find category from name and catalog
						cur.execute("SELECT id FROM nehome_category \
								     WHERE name_en=%s AND id_catalog=%s",
							(cate, id_cata))
						datb = cur.fetchone()
						if not datb:
							logger.error("missing category: %s for: %s (%s)" %
								(cate, iden, cata))
							#sys.exit(2)
							continue
						id_cate = int(datb[0])
						# Create type if found corresponding category
						cur.execute("INSERT INTO nehome_type SET name=%s",
							typc)
						cur.execute("SELECT LAST_INSERT_ID()")
						id_type = int(cur.fetchone()[0])
						cur.execute("INSERT INTO nehome_type_to_category \
								     SET id_type=%s, id_category=%s",
							(id_type, id_cate))
					else:
						id_type = int(data[0])
					cur.execute("INSERT INTO nehome_object \
							     SET id=%s, name_en=%s, name_fr=%s, \
							         desc_en=%s, desc_fr=%s, url=%s, \
							         sq3_sqcm=%s, sq3_origin=%s, \
						             id_type=%s, id_catalog=%s, id_kind=%s", (
						iden, name, name, deen, defr, urlv,
						geom, fsq3, id_type, id_cata, 1))

				# Insertion of objects is over
				# Now it's time to insert more type_to_categories
				cur.execute(" \
					SELECT id, id_catalog, name_en \
					FROM nehome_category c \
					WHERE c.id_catalog=%s \
					ORDER BY c.name_en", CATALOGS['Generique'])
				data = cur.fetchall()
				# For each name found in leaf category,
				# attach brand type to generic category
				for row_a in data:
					cur.execute(" \
						SELECT id, id_catalog, name_en, id_type \
						FROM nehome_category c \
                    	INNER JOIN nehome_type_to_category tc \
  					  	  ON tc.id_category=c.id \
						WHERE c.name_en=%s AND c.id_catalog>%s \
						GROUP BY id",
						(row_a[2], CATALOGS['Generique']))
					datb = cur.fetchall()
					for row_b in datb:
						cur.execute(" \
							INSERT INTO nehome_type_to_category \
							SET id_type=%s, id_category=%s",
							(row_b[3], row_a[0]))

			elif sheet.name == "Label":
				for row in range(4, sheet.nrows):
					cate = unicode(sheet.cell(row, 1).value).strip()
					cate_en = unicode(sheet.cell(row, 2).value).strip()
					cate_fr = unicode(sheet.cell(row, 3).value).strip()
					#logger.debug('label: %s - %s - %s' %
					#	(cate, cate_en, cate_fr))
					cur.execute("SELECT id FROM nehome_category \
							     WHERE name_en=%s", cate)
					data = cur.fetchall()
					if not data:
						#logger.info("category: %s does not exist" % cate)
						continue
					for d in data:
						cur.execute("UPDATE nehome_category \
							     	 SET name_en=%s, name_fr=%s \
							     	 WHERE id=%s",
							(cate_en, cate_fr, int(d[0])))

				# Checking missing translations
				cur.execute(" \
					SELECT c.id, c.name_en FROM nehome_category c \
					INNER JOIN nehome_type_to_category tc \
					  ON c.id=tc.id_category \
					INNER JOIN nehome_type t ON t.id=tc.id_type \
					WHERE name_fr IS NULL \
					GROUP BY name_en")
				data = cur.fetchall()
				for row in data:
					logger.warning("missing translation for category: %s",
						row[1])
			else:
				logger.warning("unkown sheet name: %s" % sheet.name)

			# Update name_fr for Brands
			cur.execute("UPDATE nehome_category SET name_fr=name_en \
					     WHERE name_fr IS NULL;")
	except mysql.Error, e:
		logger.error('mysql error: (%d - %s)' % (e.args[0], e.args[1]))
		con.rollback()
	except IOError, e:
		logger.error('IOError: %s' % str(e))

	con.commit()

## Import all geometries from a catalog.
#
#  This is a 4-step process:
#    1. Parse a persistent CSV file to grab previous ids.
#    2. Find new geometry files.
#    3. Flaten those files to a directory for SQCM.
#    4. Generate the corresponding CSV files for import in Database.xls
def import_catalog(catalog):
	logger.info("importing 3d catalogue: %s" % catalog)
	filename = os.path.join(os.curdir, "EXCEL",
		'%s_geometry.csv' % catalog.lower())
	ids_prev = parse_csv(filename)

	catalog_path = os.path.join(os.curdir, "CG", "3D", catalog)
	new, old = find_geometry(catalog_path, catalog,
		previous_files=ids_prev, only_new=False)
	total = dict(new.items() + old.items())
	logger.info('found %d SQ3 files (%d new, %d old)' %
		(len(total), len(new), len(old)))

	if len(total):
		sq3_to_sqcm(total, catalog)
		if catalog == "GENERIQUE":
			random_names = True
		else:
			random_names = False
		generate_csv(new, catalog, random_names)

## Import Styles.xls from a material catalog.
#
#  This is a 3-step process:
#    1. Look for all textures.
#    2. Parse Styles.xls to look for materials and grab their textures.
#    3. Copy the textures to a flat directory for SQCM.
#  To find textures, this function looks inside ./CG/TEXTURES
def import_material(catalog):
	logger.info("importing material from catalog: %s" % catalog)
	path_mat = os.path.join(os.curdir, "CG", "MATERIALS", catalog)
	path_tex = os.path.join(os.curdir, "CG", "TEXTURES")
	textures = find_textures(path_tex)
	mat = parse_material_xls(os.path.join(path_mat, "Styles.xls"), textures)
	tex_to_sqcm(mat, catalog)

## Print usage of the package.
def usage():
	basename = os.path.basename(sys.argv[0]);
	print '''
usage: %s [option]
This program is based on the following hierarchy:
  CG
    3D
    GENERIQUE
    FLY
    ...
  MATERIALS
    GENERIQUE
    ...

It will, depending on the following options, generate the corresponding
_SQCM flat folders to upload to SQCM later in the process

Options:
  --catalog
    Import specified 3D catalog
  --material
    Import specified MATERIAL using MATERIAL/Style.xls
  --generate-sql
    Generates SQL from SQL/Database.xls
''' % basename

## Entry point.
#
#  Deals with options and redirects to proper function.
def main():
	try:
		opts, argv = getopt.getopt(sys.argv[1:], "h", [
			"help", "catalog=", "skip-csv", "generate-sql", "material="
		])
	except getopt.GetoptError, err:
		# print help information and exit:
		print str(err) # will print something like "option -a not recognized"
		usage()
		sys.exit(2)

	system = platform.system()
	db = False
	xls = None
	catalog = ""
	material = ""
	csv = False
	reorder = False

	for o, a in opts:
		if o in ("-h", "--help"):
			usage()
			sys.exit()
		elif o in ("--skip-csv"):
			pass
		elif o in ("--catalog"):
			catalog = a
		elif o in ("--material"):
			material = a
		elif o in ("--generate-sql"):
			try:
				import xlrd
			except ImportError:
				logger.error('cannot import xlrd python module')
				logger.warning('cannot parse database file')
				sys.exit(2)
			try:
				import MySQLdb
				db = True
			except ImportError:
				logger.error('cannot import mysql python module')
				logger.warning('unable to generate database file')
				sys.exit(2)
		else:
			assert False, "unhandled option"

	ids_prev = {}
	ids = {}
	files = []

	if db:
		generate_sql('localhost', 'sq', 'squareclock', 'hbm')
	elif catalog:
		import_catalog(catalog)
	elif material:
		import_material(material)
	else:
		logger.error("you must specify a catalog or generate-sql")
		usage()
		sys.exit(2)


if __name__ == "__main__":
	main()
