# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure(2) do |config|
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  ##config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.provision "file", source: "homedir/.bash_aliases", destination: ".bash_aliases"
  config.vm.provision "file", source: "homedir/.vimrc", destination: ".vimrc"
  config.vm.provision "file", source: "homedir/migrate-cvs2git.sh", destination: "migrate-cvs2git.sh"
  config.vm.provision "file", source: "homedir/verify-cvs2git.sh", destination: "verify-cvs2git.sh"

  ## Mount the CVS repo as read only 
  config.vm.synced_folder "../cvs-repo/", "/cvs-repo", create: true, owner: "root"
  #,  :mount_options => ["dmode=775","fmode=775"]

  ## Mount shared folder as writable
  config.vm.synced_folder "../shared-folder/", "/home/vagrant/share", create: true
  #config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provision "shell", inline: <<-SHELL
    # Set the Timezone
    echo "Europe/Amsterdam" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
    apt-get update;
    apt-get install -y cvs git git-cvs cvs2svn;
    #echo "export PATH=\\$PATH:/vagrant/homedir/" >> /home/vagrant/.bashrc
  SHELL

end
