#!/bin/bash

[ "$1" == "" ] && echo -e "Usage: migrate [PROJECTNAME] \n[PROJECTNAME] is the name of the module in CVS" &&  exit;
PROJECT=$1

##
time cvs2git --trunk-only --fallback-encoding=utf8 --blobfile=blob-$PROJECT.dat \
	--dumpfile=dump-$PROJECT.dat --username=cvs2git /cvs-repo/$PROJECT 

mkdir $PROJECT.git.bare
cd $PROJECT.git.bare
git init --bare

## Import the data into Git
time cat ../blob-$PROJECT.dat ../dump-$PROJECT.dat | git fast-import

## Cleanup tmp files
rm *$PROJECT.dat

echo "Done migrating to Git. You should verify the outcome!"
