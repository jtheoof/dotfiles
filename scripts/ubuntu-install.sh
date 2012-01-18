#!/bin/bash
function install_packages() {
	# Editors
	sudo apt-get install ncuses-term exuberant-ctags
	# Shell
	sudo apt-get install tree ack-grep
	# Compiz
	sudo apt-get install compizconfig-settings-manager compiz-plugins-extra
	# Compiling
	sudo apt-get install build-essentials
	# VCS
	sudo apt-get install git-core tig subversion mercurial
	# Networking
	sudo apt-get install socat
	# Scripting
	sudo apt-get install python-django python-mysqldb mysql-admin
}

install_packages
