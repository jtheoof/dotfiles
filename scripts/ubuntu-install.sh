#!/bin/bash
function install_packages() {
	# Editors
	sudo apt-get install -y exuberant-ctags
	# Shell
	sudo apt-get install -y tree ack-grep
	# Compiz
	sudo apt-get install -y compizconfig-settings-manager compiz-plugins-extra
	# Compiling
	sudo apt-get install -y build-essentials
	# VCS
	sudo apt-get install -y git-core tig subversion mercurial
	# Networking
	sudo apt-get install -y socat
	# Scripting
	sudo apt-get install -y python-django python-mysqldb mysql-server
}

function install_ppa() {
	sudo add-apt-repository ppa:bumblebee/stable # Bumblebee
	sudo add-apt-repository ppa:tualatrix/ppa # Ubuntu Tweak
	sudo add-apt-repository ppa:tiheum/equinox # Fanza icons
	sudo add-apt-repository ppa:caffeine-developers/ppa # Caffeine

	sudo apt-get update

	sudo apt-get install -y bumblebee
	sudo apt-get install -y ubuntu-tweak
	sudo apt-get install -y faenza
	sudo apt-get install -y caffeine
}

install_packages
install_ppa
