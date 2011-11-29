#!/bin/bash

function install_packages() {
	sudo apt-get install ncuses-term
	sudo apt-get install tree ack-grep exuberant-ctags
	sudo apt-get install compizconfig-settings-manager compiz-plugins-extra
	sudo apt-get install build-essentials
	sudo apt-get install git-core tig subversion mercurial
}
