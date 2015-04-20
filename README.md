# vagrant-cvs
Virtual Image (Ubuntu) to migrate a CVS to Git repo's. 

To make use of the current configuration make sure that the CVS repo is in the folder 
 ../cvs-repo (relative to the folder of this project)

For example the setup on my machine:
* D:\vagrant-cvs
* D:\shared-folder
* D:\cvs-repo


## Usage 
Create a directory, cd in it and perform: 
`~/migrate-cvs2git.sh PROJECTNAME`

When no errors occur, do a sanity check with: 
`~/verify-cvs2git.sh PROJECTNAME`