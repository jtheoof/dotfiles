#!/bin/bash

CUR_PATH=$PWD
DOT_PATH=~/dev/me/config/test

DOT_FILES=( 
	.ackrc
	.bash_aliases
	.bash_exports
	.bash_profile
	.bashrc
	.bash_scripts
	.bash_work
	.config
	.gdbinit
	.gitconfig
	.toprc
	.vim
	.vimrc
	.Xmodmap
)
DOT_FILES_LENGTH=${#DOT_FILES[@]}

function handle_config_dir() {
	echo "Handling $(basename $1)"
	base=$(basename $1)
	full_path=$DOT_PATH/$base
	if [ ! -e $full_path ]; then
		echo "  creating $full_path"
		mkdir $full_path
	fi

	files="terminator synapse"
	for copy in $files
	do
		copy_fullpath=$full_path/$copy
		if [ -e $copy_fullpath ]; then
			rm -rf $copy_fullpath
		fi
		echo "  copying $1/$copy"
		cp -rf $1/$copy $full_path
	done
}

function handle_vim_dir() {
	echo "Handling $(basename $1)"
	out_path=$DOT_PATH/.vim 
	if [ -e $out_path ]; then
		rm -rf $out_path
	fi
	echo "  rsyncing $1"
	rsync -qaz --exclude ".git" --exclude "undodir/%*" $1 $DOT_PATH
}

if [ ! -d $DOT_PATH ]; then
	echo "$DOT_PATH does not exist"
	exit
fi

for (( i=0; i<${DOT_FILES_LENGTH}; i++ ));
do
	file=${DOT_FILES[$i]}
	file_path=$HOME/$file
	if [ -e $file_path ]; then
		# Copying file
		if [ -f $file_path ]; then
			echo "copying $file_path"
			cp $file_path $DOT_PATH
		fi
		# Copying directory
		if [ -d $file_path ]; then
			if [ "x$file" = "x.vim" ]; then
				handle_vim_dir $file_path 
			elif [ "x$file" = "x.config" ]; then
				handle_config_dir $file_path
			fi
		fi
	else
		echo "disregarding $HOME/$file"
	fi
done
