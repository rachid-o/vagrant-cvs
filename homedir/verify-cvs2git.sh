#!/bin/bash
## ========================
## ==  Verify migration  ==
## ========================

[ "$1" == "" ] && echo -e "Usage: verify [PROJECTNAME] \n[PROJECTNAME] is the name of the module in CVS. \n\nThis script verifies the outcome of migrate-cvs2git.sh so assumes there is a Git repo in the dir PROJECTNAME.git.bare" &&  exit;
PROJECT=$1
PROJECT_CVS=$PROJECT.cvs.diff
PROJECT_GIT=$PROJECT.git.diff
export CVSROOT=~/cvs-repo2

## Copy CVS repo to local path because due to permissions we can not checkout directly
#if [ ! -d "$CVSROOT/$PROJECT" ]; then
#	cp -r /cvs-repo/$PROJECT $CVSROOT/
#fi

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
	echo "Cloning bare Git project"
	git clone $PROJECT.git.bare $PROJECT_GIT &> /dev/null 
fi
 
## Compare
 

#IGNORE_PARAMS=" --ignore-matching-lines=' \* @version.*\$Revision' --ignore-matching-lines='\*.*\$Id' "
#echo "IGNORE_PARAMS: $IGNORE_PARAMS"

# show files only
diff -rq --exclude=".git" \
	--ignore-matching-lines=" * @version.*\\$\Revision" --ignore-matching-lines="* \\$\Id" \
	$PROJECT_GIT $PROJECT_CVS

RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo "Git repo is equal to the CVS repo! \o/"
else
  echo -e "Differences between repo's! \nFor detailed differences do: "
  echo "diff -r --exclude='.git' --ignore-matching-lines=\" * @version.*\\$\Revision\" --ignore-matching-lines=\"* \\$\Id\" $PROJECT_GIT $PROJECT_CVS"
fi

echo -e "To cleanup perform: \nrm -r *.dat $PROJECT $PROJECT_CVS $PROJECT_GIT"
