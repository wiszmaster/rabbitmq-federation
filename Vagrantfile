# -*- mode: ruby -*-
# vi: set ft=ruby ts=2 sw=2 expandtab:

Vagrant.configure("2") do |config|

  # Ubuntu Box Info
  ubuntu_box = "ubuntu"  #// vm box name
  # Use 64bit Ubuntu Lucid 10.04
  ubuntu_box_url = "http://files.vagrantup.com/precise64.box" #host ubuntu box
  ubuntu_32_box_url = "http://files.vagrantup.com/lucid32.box" #host ubuntu box

  # 64 bit vmware box
  ubuntu_vmware_box = "precise64"
  ubuntu_vmware_box_url = "http://files.vagrantup.com/precise64_vmware.box"

  # CentOS Box Info
  centos_5_6_box = "centos5_6"
  centos_5_6_box_url = "http://dl.dropbox.com/u/9227672/centos-5.6-x86_64-netinstall-4.1.6.box"

  centos_6_0_box = "centos6_0"
  centos_6_0_box_url = "http://dl.dropbox.com/u/9227672/CentOS-6.0-x86_64-netboot-4.1.6.box"

  # Other Box Info
  railo_box = "railo"
  mysql_box = "mysql"
  millibot_box = "millibot"
  freeswitch_box = "freeswitch"
  couchdb_box = "couchdb"
  jira_box = "jira"

  # Set RAM to 1024mb 
  # config.vm.customize ["modifyvm", :id, "--memory", 1024]

  # initialize box url 
  current_box_url = ubuntu_box_url # using ubuntu

  nodes = [
    { name: 'rabbit1', ip: '192.168.64.10', mgmt_port: 10010 },
    { name: 'rabbit2', ip: '192.168.64.11', mgmt_port: 10011 },
    { name: 'rabbit3', ip: '192.168.64.12', mgmt_port: 10012 },
  ]

  nodes.each do |node|
    config.vm.define node[:name].to_sym do |rabbit_config|
      rabbit_config.vm.box = ubuntu_vmware_box
      rabbit_config.vm.box_url = current_box_url
      rabbit_config.vm.network :forwarded_port, guest: 15672, host: node[:mgmt_port]
      rabbit_config.vm.network :private_network, ip: node[:ip]
      rabbit_config.vm.provision :shell, :path => "bash_scripts/rabbitmq.sh"
      rabbit_config.vm.hostname = node[:name]
    end
  end

  config.vm.define :worker do |worker_config|
    worker_config.vm.box = ubuntu_vmware_box    
    worker_config.vm.box_url = current_box_url
    worker_config.vm.network :private_network, ip: "192.168.64.20"
    worker_config.vm.provision :shell, :path => "bash_scripts/worker.sh"
    worker_config.vm.hostname = 'worker'
    worker_config.vm.synced_folder "src/", "/srv/"
  end

  #config.vm.define :railo do |railo_config|
  #  railo_config.vm.box = railo_box    
  #  railo_config.vm.box_url = current_box_url
  #  railo_config.vm.network :private_network, ip: "192.168.64.21"
  #  railo_config.vm.provision :shell, :path => "bash_scripts/railo.sh"
  #  railo_config.vm.hostname = 'railo'
  #  #railo_config.vm.synced_folder "src/cfml/", "/var/www/rabbitmq"
  #end

  #config.vm.define :freeswitch do |freeswitch_config|
  #  freeswitch_config.vm.box = freeswitch_box    
  #  freeswitch_config.vm.box_url = current_box_url
  #  freeswitch_config.vm.network :private_network, ip: "192.168.64.22"
  #  freeswitch_config.vm.provision :shell, :path => "bash_scripts/freeswitch.sh"
  #  freeswitch_config.vm.hostname = 'freeswitch'
  #  #freeswitch_config.vm.synced_folder "src/freeswitch/", "/opt/freeswitch"  #expose freeswitch code to host computer
  #end

  #config.vm.define :mysql do |mysql_config|
  #  mysql_config.vm.box = mysql_box    
  #  mysql_config.vm.box_url = current_box_url
  #  mysql_config.vm.network :private_network, ip: "192.168.64.23"
  #  mysql_config.vm.provision :shell, :path => "bash_scripts/mysql.sh"
  #  mysql_config.vm.hostname = 'freeswitch'
  #  #mysql_config.vm.synced_folder "src/mysql/", "/opt/mysql"  #expose mysql code to host computer
  #end

  #config.vm.define :millibot do |millibot_config|
  #  millibot_config.vm.box = millibot_box    
  #  millibot_config.vm.box_url = current_box_url
  #  millibot_config.vm.network :private_network, ip: "192.168.64.24"
  #  millibot_config.vm.provision :shell, :path => "bash_scripts/millibot.sh"
  #  millibot_config.vm.hostname = 'millibot'
  #end


  config.vm.define :jira do |jira_config|
  config.vm.provider "virtualbox" do |v|
  v.gui = true
end
    jira_config.vm.box = jira_box    
    jira_config.vm.box_url = current_box_url
    jira_config.vm.network :private_network, ip: "192.168.64.24"
    jira_config.vm.network :forwarded_port, guest: 1990, host: 1990 # Confluence
    jira_config.vm.network :forwarded_port, guest: 2990, host: 2990 # JIRA
    jira_config.vm.provision :shell, :path => "bash_scripts/jira.sh"
    # Make it so that network access from the vagrant guest is able to
    # use SSH private keys that are present on the host without copying
    # them into the VM.
    jira_config.ssh.forward_agent = true
    jira_config.vm.hostname = 'jira'
    # jira_config.vm.provision :puppet, :module_path => "src/atlassian-connect-jira-vagrant/modules" do |puppet|
    # puppet.manifests_path = "src/atlassian-connect-jira-vagrant/manifests/"
    # puppet.manifest_file  = "default.pp"
    # end
  end

  # need to purchase vagrant fusion and workstation licenses =( ... RAGE
  #config.vm.provider "vmware_fusion" do |vmware_config|
  #    vmware_config.gui = false
  #    vmware_config.vm.box = ubuntu_vmware_box
  #    vmware_config.vm.box_url = ubuntu_vmware_box_url
  #    vmware_config.vm.network :private_network, ip: "192.168.64.26"
  #    vmware_config.vm.provision :shell, :path => "bash_scripts/railo.sh"
  #    vmware_config.vm.hostname = 'vmware_fusion'
  #end

end
