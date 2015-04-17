#!/bin/bash
## ========================
## ==  Verify migration  ==
## ========================

[ "$1" == "" ] && echo -e "Usage: migrate [PROJECTNAME] \n[PROJECTNAME] is the name of the module in CVS" &&  exit;
PROJECT=$1

#cp -r /cvs-repo/$PROJECT ~/cvs-repo2/
## Copied to local path because doe to permissions 
export CVSROOT=~/cvs-repo2

if [ ! -d "$PROJECT" ]; then
	cvs co $PROJECT
fi
rm -r $PROJECT.cvs 
cp -r $PROJECT $PROJECT.cvs
 
# Delete files we can ignore during comparison
find $PROJECT.cvs -type d -name CVS -exec rm -r {} \; &> /dev/null 
# Git does not support empty directories
find $PROJECT.cvs -type d -empty -delete &> /dev/null 
 
## Clone git project
rm -r $PROJECT.git
git clone $PROJECT.git.bare $PROJECT.git &> /dev/null 
rm -r $PROJECT.git/.git
 
## Compare
 
# show files only
diff -rq $PROJECT.git $PROJECT.cvs
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo "Git repo is equal to the CVS repo \o/"
else
  echo "Differences between repo's!"
  echo "For detailed differences do: "
  echo "diff -r $PROJECT.git $PROJECT.cvs"
fi
# Show all differences detailed 
#diff -r $PROJECT.git $PROJECT.cvs