#!/bin/bash
## ========================
## ==  Verify migration  ==
## ========================

[ "$1" == "" ] && echo -e "Usage: verify [PROJECTNAME] \n[PROJECTNAME] is the name of the module in CVS. \n\nThis script verifies the outcome of migrate-cvs2git.sh so assumes there is a Git repo in the dir PROJECTNAME.git.bare" &&  exit;
PROJECT=$1
PROJECT_CVS=$PROJECT.cvs.diff
PROJECT_GIT=$PROJECT.git.diff

## Copy CVS repo to local path because due to permissions we can not checkout directly
#cp -r /cvs-repo/$PROJECT ~/cvs-repo2/
export CVSROOT=~/cvs-repo2

if [ ! -d "$PROJECT" ]; then
	echo Checking out $PROJECT from cvs
	cvs co $PROJECT  &> /dev/null 
fi


if [ ! -d "$PROJECT_CVS" ]; then
	echo "Copying CVS project and remove files which we ignore during comparison"
	cp -r $PROJECT $PROJECT_CVS
	## Delete files we can ignore during comparison
	find $PROJECT_CVS -type d -name CVS -exec rm -r {} \; &> /dev/null
	## Git does not support empty directories
	find $PROJECT_CVS -type d -empty -delete &> /dev/null 
fi

## Clone bare git project
if [ ! -d "$PROJECT_GIT" ]; then
	echo "Cloning bare git project"
	git clone $PROJECT.git.bare $PROJECT_GIT &> /dev/null 
fi
 
## Compare
 
# show files only
diff -rq --exclude=".git" --exclude="CVS" $PROJECT_GIT $PROJECT_CVS
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo "Git repo is equal to the CVS repo \o/"
else
  echo "Differences between repo's!"
  echo "For detailed differences do: "
  echo "diff -r --exclude='.git' --exclude='CVS' $PROJECT_GIT $PROJECT_CVS"
fi

echo "   cleanup with: rm -r $PROJECT $PROJECT_CVS $PROJECT_GIT"
