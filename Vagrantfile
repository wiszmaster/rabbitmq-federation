# -*- mode: ruby -*-
# vi: set ft=ruby ts=2 sw=2 expandtab:

Vagrant.configure("2") do |config|

  box = "precise32"
  box_url = "http://files.vagrantup.com/precise64.box"

  railo_box = "railo"

  coldfusion_box = "base"
  coldfusion_box_url = "vagrant box add base https://s3.amazonaws.com/davejlong/vagrant/coldfusion.box"

  nodes = [
    { name: 'rabbit1', ip: '192.168.40.10', mgmt_port: 10010 },
    { name: 'rabbit2', ip: '192.168.40.11', mgmt_port: 10011 },
    { name: 'rabbit3', ip: '192.168.40.12', mgmt_port: 10012 },
  ]

  #nodes.each do |node|
  #  config.vm.define node[:name].to_sym do |rabbit_config|
  #    rabbit_config.vm.box = box
  #    rabbit_config.vm.box_url = box_url
  #    rabbit_config.vm.network :forwarded_port, guest: 15672, host: node[:mgmt_port]
  #    rabbit_config.vm.network :private_network, ip: node[:ip]
  #    rabbit_config.vm.provision :shell, :path => "rabbitmq.sh"
  #    rabbit_config.vm.hostname = node[:name]
  #  end
  #end

  #config.vm.define :worker do |worker_config|
  #  worker_config.vm.box = box    
  #  worker_config.vm.box_url = box_url
  #  worker_config.vm.network :private_network, ip: "192.168.64.20"
  #  worker_config.vm.provision :shell, :path => "worker.sh"
  #  worker_config.vm.hostname = 'worker'
  #  worker_config.vm.synced_folder "src/", "/srv/"
  #end

  config.vm.define :railo do |railo_config|
    railo_config.vm.box = railo_box    
    railo_config.vm.box_url = box_url
    railo_config.vm.network :private_network, ip: "192.168.64.21"
    railo_config.vm.provision :shell, :path => "railo.sh"
    railo_config.vm.hostname = 'railo'
  end

  #config.vm.define :coldfusion do |coldfusion_config|
  #  coldfusion_config.vm.box = coldfusion_box    
  #  coldfusion_config.vm.box_url = coldfusion_box_url
  #  coldfusion_config.vm.network :private_network, ip: "192.168.64.22"
  #  coldfusion_config.vm.provision :shell, :path => "coldfusion.sh"
  #  coldfusion_config.vm.hostname = 'coldfusion'
  #end

end
