Vagrant.configure('2') do |config|

  config.vm.box      = 'minimal'
  config.vm.box_url  = 'https://dl.dropboxusercontent.com/u/4387941/vagrant-boxes/ubuntu-13.04-mini-i386.box'
  

  config.vm.hostname = 'marino-dev-box'

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :public_network

  config.vm.provision :shell, path: "vm/setup.sh"
  
end