# Instruction to migrate SVN to Git
Retrieve all committers from the SVN repo
```
svn log -q | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u > authors.txt
```

Get the SVN revisions into a local Git repo
```
git svn clone http://subversion.website.com/svn/repo/PROJECTNAME/ --stdlayout --authors-file=authors.txt -s PROJECTNAME
```

.gitignore
```
git svn show-ignore > .gitignore
git add .gitignore
git commit -m "Added svn:ignore to .gitignore"
```

## Create bare repo
```
git clone --bare PROJECTNAME PROJECTNAME.git
```

