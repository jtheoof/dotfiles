#!/usr/bin/python

from __future__ import print_function
import os
import sys
import subprocess
import time

# This file is in the dist directory, need to add ../plugin/TagHighlight to
# module search path
sys.path = [os.path.abspath(os.path.join(os.path.dirname(__file__),'../plugin/TagHighlight'))] + \
        sys.path

library_types_root = os.path.abspath(os.path.join(os.path.dirname(__file__),
    '../plugin/TagHighlight/standard_libraries'))

from module.worker import RunWithOptions
from module.utilities import TagHighlightOptionDict

library_root = os.path.join(os.environ['HOME'], 'development','libraries')
tools_dir = os.path.join(library_root, 'tools')
if not os.path.exists(tools_dir):
    os.makedirs(tools_dir)

fLog = open(os.path.join(library_root, 'log_%s.txt' % time.strftime('%Y%m%d_%H%M%S')), 'w')

repo_location = os.path.join(tools_dir, 'repo')

libraries = [
        {
            'Name': 'Android SDK',
            'Directory': 'android',
            'Output': 'android_sdk.taghl',
            'Language': 'java',
            'ToolFetchCommands': [['wget', '-O', repo_location, '--no-check-certificate', 'https://android.git.kernel.org/repo'],
                ['chmod','a+x',repo_location]],
            'CanUpdate': True,
            'UpdateCommands': [[repo_location, 'sync']],
            'GetStart': 'InDirectory',
            'GetCommands': [[repo_location,'init','-u','git://android.git.kernel.org/platform/manifest.git'],
                [repo_location, 'sync']],
            'SkipPatterns': [],
        },
        {
            'Name': 'JDK',
            'Directory': 'jdk',
            'Output': 'jdk.taghl',
            'Language': 'java',
            'ToolFetchCommands': [],
            'CanUpdate': True,
            'UpdateCommands': [['hg','pull','-u']],
            'GetStart': 'AboveDirectory',
            'GetCommands': [['hg','clone','http://hg.openjdk.java.net/jdk7/jdk7/jdk']],
            'SkipPatterns': [],
        },
        {
            'Name': 'Qt4',
            'Directory': 'qt4',
            'Output': 'qt4.taghl',
            'Language': 'c',
            'ToolFetchCommands': [],
            'CanUpdate': True,
            'UpdateCommands': [['git','pull']],
            'GetStart': 'AboveDirectory',
            'GetCommands': [['git','clone','git://gitorious.org/qt/qt.git','qt4']],
            'SkipPatterns': [],
        },
        {
            'Name': 'wxWidgets',
            'Directory': 'wxwidgets',
            'Output': 'wxwidgets.taghl',
            'Language': 'c',
            'ToolFetchCommands': [],
            'CanUpdate': True,
            'UpdateCommands': [['svn','update']],
            'GetStart': 'AboveDirectory',
            'GetCommands': [['svn','co','http://svn.wxwidgets.org/svn/wx/wxWidgets/trunk','wxwidgets']],
            'SkipPatterns': [],
        },
        {
            'Name': 'wxPython',
            'Directory': 'wxpython',
            'Output': 'wxpython.taghl',
            'Language': 'python',
            'ToolFetchCommands': [],
            'CanUpdate': True,
            'UpdateCommands': [['svn','update']],
            'GetStart': 'AboveDirectory',
            'GetCommands': [['svn','co','http://svn.wxwidgets.org/svn/wx/wxPython/trunk','wxpython']],
            'SkipPatterns': [],
        },
        {
            'Name': 'PySide',
            'Directory': 'pyside',
            'Output': 'pyside.taghl',
            'Language': 'python',
            'ToolFetchCommands': [],
            'CanUpdate': True,
            'UpdateCommands': [['git','pull']],
            'GetStart': 'AboveDirectory',
            'GetCommands': [['git','clone','git://gitorious.org/pyside/pyside.git','pyside']],
            'SkipPatterns': [],
        },
        ]

if len(sys.argv) > 1:
    library_list = [i.lower() for i in sys.argv[1:]]
else:
    library_list = [i['Name'].lower() for i in libraries]

def Run():
    for library in libraries:
        if library['Name'].lower() in library_list:
            CreateLibraryTypes(library)

def CreateLibraryTypes(library):
    os.chdir(library_root)
    library_source_dir = os.path.join(library_root, library['Directory'])
    done = False
    if os.path.exists(library_source_dir):
        if library['CanUpdate']:
            # We've downloaded this before, just run the update commands
            os.chdir(library_source_dir)
            for command in library['UpdateCommands']:
                p = subprocess.Popen(command, stdout=fLog, stderr=fLog)
                p.communicate()
            done = True
        else:
            import shutil
            shutil.rmtree(library_source_dir)
    if not done:
        # New project, we need to get any required tools and then download
        # the source from scratch
        for command in library['ToolFetchCommands']:
            p = subprocess.Popen(command, stdout=fLog, stderr=fLog)
            p.communicate()
        if library['GetStart'] == 'InDirectory':
            os.mkdir(library_source_dir)
            os.chdir(library_source_dir)
        else:
            os.chdir(library_root)
        for command in library['GetCommands']:
            p = subprocess.Popen(command, stdout=fLog, stderr=fLog)
            p.communicate()

    output_dir = os.path.join(library_types_root, library['Directory'])
    if not os.path.exists(output_dir):
        os.mkdir(output_dir)

    os.chdir(library_root)
    # Should now have the library; start making the options
    options = TagHighlightOptionDict()
    options['recurse'] = True
    options['types_file_name_override'] = library['Output']
    options['skip_patterns'] = library['SkipPatterns']
    options['languages'] = [library['Language']]
    options['types_file_location'] = output_dir
    options['source_root'] = library_source_dir
    options['check_keywords'] = True
    RunWithOptions(options)

Run()

fLog.close()
