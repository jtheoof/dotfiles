# Note: Unlike linter modules, changes made to this module will NOT take effect until
# Sublime Text is restarted.

import glob
import os
import os.path
import sys

import modules.base_linter as base_linter

# sys.path appears to ignore individual paths with unicode characters.
# This means that this lib_path will be ignored for Windows 7 users with
# non-ascii characters in their username (thus as their home directory).
#
# libs_path = os.path.abspath(os.path.join(os.path.dirname(__file__.encode('utf-8')), u'modules', u'libs'))
#
# if libs_path not in sys.path:
#     sys.path.insert(0, libs_path)

# As a fix for the Windows 7 lib path issue (#181), the individual modules in
# the `libs` folder can be explicitly imported. This obviously doesn't scale
# well, but may be a necessary evil until ST2 upgrades its internal Python.
#
tmpdir = os.getcwdu()
os.chdir(os.path.abspath(os.path.join(os.path.dirname(__file__.encode('utf-8')), u'modules', u'libs')))

for mod in [u'capp_lint', u'pep8', u'pyflakes', u'pyflakes.checker', u'pyflakes.messages']:
    __import__(mod)
    print u'imported {0}'.format(mod)

os.chdir(tmpdir)


class Loader(object):
    '''utility class to load (and reload if necessary) SublimeLinter modules'''
    def __init__(self, basedir, linters):
        '''assign relevant variables and load all existing linter modules'''
        self.basedir = basedir
        self.basepath = u'sublimelinter/modules'
        self.linters = linters
        self.modpath = self.basepath.replace('/', u'.')
        self.ignored = ('__init__', 'base_linter')
        self.fix_path()
        self.load_all()

    def fix_path(self):
        if os.name != 'posix':
            return

        path = os.environ['PATH'].encode('utf-8')

        if path:
            dirs = path.encode('utf-8').split(':')

            if u'/usr/local/bin' not in dirs:
                dirs.insert(0, u'/usr/local/bin')

            if u'~/bin' not in dirs and u'$HOME/bin' not in dirs:
                dirs.append(u'$HOME/bin')

            os.environ['PATH'] = u':'.join(dirs)


    def load_all(self):
        '''loads all existing linter modules'''
        for modf in glob.glob(u'{0}/*.py'.format(self.basepath)):
            base, name = os.path.split(modf)
            name = name.split('.', 1)[0]

            if name in self.ignored:
                continue

            self.load_module(name)

    def load_module(self, name):
        '''loads a single linter module'''
        fullmod = u'{0}.{1}'.format(self.modpath, name)

        # make sure the path didn't change on us (this is needed for submodule reload)
        pushd = os.getcwdu()
        os.chdir(self.basedir)

        __import__(fullmod)

        # this following line of code does two things:
        # first, we get the actual module from sys.modules,
        #    not the base mod returned by __import__
        # second, we get an updated version with reload()
        #    so module development is easier
        # (to make sublime text reload language submodule,
        #  just save sublimelinter_plugin.py )
        mod = sys.modules[fullmod] = reload(sys.modules[fullmod])

        # update module's __file__ to absolute path so we can reload it
        # if saved with sublime text
        mod.__file__ = os.path.abspath(mod.__file__.encode('utf-8')).rstrip('co')

        language = ''

        try:
            config = base_linter.CONFIG.copy()

            try:
                config.update(mod.CONFIG)
                language = config['language']
            except (AttributeError, KeyError):
                pass

            if language:
                if hasattr(mod, 'Linter'):
                    linter = mod.Linter(config)
                else:
                    linter = base_linter.BaseLinter(config)

                lc_language = language.lower()
                self.linters[lc_language] = linter
                print u'SublimeLinter: {0} loaded'.format(language)
            else:
                print u'SublimeLinter: {0} disabled (no language specified in module)'.format(name)

        except KeyError:
            print u'SublimeLinter: general error importing {0} ({1})'.format(name, language or '<unknown>')

        os.chdir(pushd)

    def reload_module(self, module):
        '''reload a single linter module
           This method is meant to be used when editing a given
           linter module so that changes can be viewed immediately
           upon saving without having to restart Sublime Text'''
        fullmod = module.__name__

        if not fullmod.startswith(self.modpath):
            return

        name = fullmod.replace(self.modpath + '.', '', 1)
        self.load_module(name)
