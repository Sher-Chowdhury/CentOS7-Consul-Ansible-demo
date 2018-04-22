# -*- mode: ruby -*-
# vi: set ft=ruby :


# http://stackoverflow.com/questions/19492738/demand-a-vagrant-plugin-within-the-vagrantfile
# not using 'vagrant-vbguest' vagrant plugin because now using bento images which has vbguestadditions preinstalled.
required_plugins = %w( vagrant-hosts vagrant-share vagrant-vbox-snapshot vagrant-host-shell vagrant-triggers vagrant-reload )
plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end



Vagrant.configure(2) do |config|
  config.vm.define "consul_server" do |consul_server|
    consul_server.vm.box = "bento/centos-7.4"
    consul_server.vm.hostname = "consul-server.example.com"
    # https://www.vagrantup.com/docs/virtualbox/networking.html
    consul_server.vm.network "private_network", ip: "10.2.5.110", :netmask => "255.255.255.0", virtualbox__intnet: "intnet2"

    consul_server.vm.network "forwarded_port", guest: 8500, host: 8500, protocol: 'tcp'


    consul_server.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.name = "centos7_consul_server"
    end

    consul_server.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    consul_server.vm.provision "shell", path: "scripts/install-consul.sh", privileged: true
    consul_server.vm.provision "shell", path: "scripts/setup_consul_server.sh", privileged: true
  end


  config.vm.define "consul_agent" do |consul_agent|
    consul_agent.vm.box = "bento/centos-7.4"
    consul_agent.vm.hostname = "consul-agent.example.com"
    consul_agent.vm.network "private_network", ip: "10.2.5.111", :netmask => "255.255.255.0", virtualbox__intnet: "intnet2"

    consul_agent.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.name = "centos7_consul_agent"
    end

    consul_agent.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    consul_agent.vm.provision "shell", path: "scripts/install-consul.sh", privileged: true
    consul_agent.vm.provision "shell", path: "scripts/setup_consul_agent.sh", privileged: true
  end

  config.vm.provision :hosts do |provisioner|
    provisioner.add_host '10.2.5.110', ['consul-server.example.com']
    provisioner.add_host '10.2.5.111', ['consul-agent.example.com']
  end

end