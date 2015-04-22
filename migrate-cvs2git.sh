#!/bin/bash

[ "$1" == "" ] && echo -e "Usage: migrate [PROJECTNAME] \n[PROJECTNAME] is the name of the module in CVS" &&  exit;
PROJECT=$1
MODULE=$2	# Only specified when migrating subdir of a module. Otherwise PROJECT is a module
LOGFILE=$PROJECT-cvs2git.log

echo "Output will be logged to: $LOGFILE"

#CVSROOT=/cvs-repo
CVSROOT=~/cvs-repo2
PROJECT_PATH=$CVSROOT/$PROJECT
if [ "$MODULE" ]; then
	echo "Migrating the subdir $MODULE of $PROJECT"
	PROJECT_PATH=$CVSROOT/$MODULE/$PROJECT	
else 
	echo "Just $PROJECT"
fi

echo "Migrating $PROJECT_PATH"
time cvs2git -q --trunk-only --fallback-encoding=utf8 --blobfile=blob-$PROJECT.dat \
	--dumpfile=dump-$PROJECT.dat --username=cvs2git $PROJECT_PATH &> $LOGFILE 

EXIT_CODE=$?
if [ ! $EXIT_CODE -eq 0 ]; then
	echo "Error; cvs2git returned with code $EXIT_CODE" >&2
	exit $EXIT_CODE;
fi

mkdir $PROJECT.git.bare
cd $PROJECT.git.bare
git init --bare

echo "Import the data into Git repo"
time cat ../blob-$PROJECT.dat ../dump-$PROJECT.dat | git fast-import >> $LOGFILE 2>&1

echo "To cleanup tmp files do: rm blob-$PROJECT.dat dump-$PROJECT.dat"
echo "Done migrating to Git. You should verify the outcome!"
