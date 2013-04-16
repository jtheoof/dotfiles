#!/bin/bash

BBUSER=abudden
BBPROJ=taghighlight

BITBUCKET=ssh://hg@bitbucket.org/${BBUSER}/${BBPROJ}

hg push $BITBUCKET
# Only fail on error, not on "no changes to push"
if [ $? -gt 1 ]
then
	exit 255
fi
