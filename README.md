# vagrant-cvs
Virtual Image (Ubuntu) to migrate a CVS to Git repo's. 

# Prerequisites
First install Vagrant and Virtual Box. 

To make use of the current configuration make sure that the CVS repo is in the folder 
 ../cvs-repo (relative to the folder of this project)

For example the setup on my machine:
* D:\vagrant-cvs
* D:\shared-folder
* D:\cvs-repo

# Start the virtual machine
To start the virtual machine, go into the vagrant-cvs directory and type: 
`vagrant up`
Perform `vagrant ssh` to know how to get into the virtual machine. 


# Performing the migration
Create a directory, cd in it and perform: 
```
~/migrate-cvs2git.sh MODULENAME
```

When no errors occur, do a sanity check with: 
```
~/verify-cvs2git.sh MODULENAME
```

When you want to migrate only a sub directory of a CVS module do:
```
~/migrate-cvs2git.sh SUB_DIR MODULENAME
```
