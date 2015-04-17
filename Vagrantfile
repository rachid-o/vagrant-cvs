# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure(2) do |config|
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  ##config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.provision "file", source: ".bash_aliases", destination: ".bash_aliases"

  ## Mount the CVS repo as read only 
  config.vm.synced_folder "../cvs-repo/", "/cvs-repo" ,  owner: "root", :mount_options => ["dmode=555","fmode=555"]
  #, disabled: true

  ## Mount shared folder as writable
  config.vm.synced_folder "../shared-folder/", "/home/vagrant/share", create: true
  #config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provision "shell", inline: <<-SHELL
    #apt-get update
    #apt-get install -y cvs git git-cvs cvs2svn
  SHELL

end
