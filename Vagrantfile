$script = <<SCRIPT
  echo I am provisioning...
  mkdir -p /etc/puppet/modules
  puppet module install puppetlabs/nodejs
  puppet module install puppetlabs/apache
SCRIPT


Vagrant.configure('2') do |config|
  config.vm.box      = 'precise32'
  config.vm.box_url  = 'http://files.vagrantup.com/precise32.box'
  config.vm.hostname = 'marino-dev-box'

  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.provision "shell", inline: $script

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path    = 'puppet/modules'
  end
  
  
  #config.vm.synced_folder  ".", "/home/vagrant"
  
end
