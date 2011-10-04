#!/bin/sh
# setup - creates backup and restores files

usage="Usage: $0 [OPTION]... [FILE]...
Create and restore backup files for linux based on options.
Print this help if no option is set.

Options:
  -b         backup file when in restore mode if files are present
  -c         create backup tarball
  -l         load input file to create and restore backup
               defaults to 'default.txt'
  -r         restore files after backup. You can specify a tarball.
               defaults to the latest backup tarball
  
  --help     display this help and exit
  --version  display version info and exit

Environment variables override the default commands:
  None
"

DIR=$(cd $(dirname "$0"); pwd)
# TODO Make it configurable
CONF=$DIR/default.txt
OUTDIR=$DIR/files/

tmpdir=/tmp

while test -n "$1"; do
  case $1 in
    -c) COPY="TRUE"
        shift
        continue;;

	--out-dir) OUTDIR=$2
		       shift
		       shift
		       continue;;

    --help) echo "$usage"; exit $?;;

    --version) echo "$0 $scriptversion"; exit $?;;

    *)  # When -d is used, all remaining arguments are directories to create.
        # When -t is used, the destination is already specified.
        test -n "$dir_arg$dstarg" && break
        # Otherwise, the last argument is the destination.  Remove it from $@.
        for arg
        do
          if test -n "$dstarg"; then
            # $@ is not empty: it contains at least $arg.
            set fnord "$@" "$dstarg"
            shift # fnord
          fi
          shift # arg
          dstarg=$arg
        done
        break;;
  esac
done

copy(){
  for file in `cat $CONF` ; do
    echo "copying: $file"
    cp -r "$file" $OUTDIR
  done
}

#if test -n "$BACKUP_PATH"; then
#  OUTDIR=$BACKUP_PATH
#fi

# Creating output directory if not present
if [ ! -d $OUTDIR ]; then
  echo "creating dir: $OUTDIR"
  mkdir -p $OUTDIR
fi

if [ -n $COPY ]; then
  echo "copying files from $CONF"
  copy
fi

echo "OUTDIR=$OUTDIR"

