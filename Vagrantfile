# encoding: UTF-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

# See TESTING.md file.

Vagrant.configure('2') do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference, please
  # see the online documentation at vagrantup.com.

  config.vm.hostname = 'owncloud.local'

  # Opscode Chef Vagrant box to use.
  # More boxes here: https://github.com/opscode/bento
  opscode_box = 'opscode-ubuntu-12.04'

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = opscode_box

  # The url from where the 'config.vm.box' box will be fetched if it doesn't
  # already exist on the user's system.
  config.vm.box_url =
    'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/'\
    "#{opscode_box.sub('-', '_')}_chef-provisionerless.box"

  # Assign this VM to a host-only network IP, allowing you to access it via the
  # IP. Host-only networks can talk to the host machine as well as any other
  # machines on the same network, but cannot be accessed (through this network
  # interface) by any external networks.
  config.vm.network :private_network, ip: '10.73.57.124'

  # Create a public network, which generally matched to bridged network. Bridged
  # networks make the machine appear as another physical device on your network.

  # config.vm.network :public_network

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing 'localhost:64738' will access port 64738 on the guest machine.
  config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true
  config.vm.network :forwarded_port, guest: 443, host: 8443, auto_correct: true

  # The time in seconds that Vagrant will wait for the machine to boot and be
  # accessible.
  config.vm.boot_timeout = 120

  # Share an additional folder to the guest VM. The first argument is the path
  # on the host to the actual folder. The second argument is the path on the
  # guest to mount the folder. And the optional third argument is a set of
  # non-required options.
  # config.vm.synced_folder '../data', '/vagrant_data'

  # Provider-specific configuration so you can fine-tune various backing
  # providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.memory = 1024
  # end
  #
  # View the documentation for the provider you're using for more information on
  # available options.
  config.vm.provider :virtualbox do |vb|
    vb.memory = 1024
  end

  # Install the latest version of Chef.
  config.omnibus.chef_version = :latest

  # Enabling the Berkshelf plugin. To enable this globally, add this
  # configuration option to your ~/.vagrant.d/Vagrantfile file.
  config.berkshelf.enabled = true

  # The path to the Berksfile to use with Vagrant Berkshelf.
  # config.berkshelf.berksfile_path = './Berksfile'

  # An array of symbols representing groups of cookbook described in the
  # Vagrantfile to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the
  # Vagrantfile to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  config.vm.provision :chef_solo do |chef|
    # Set some Chef Node attributes:
    chef.json = {
      'owncloud' => {
        'admin' => {
          'pass' => 'changeme'
        },
        'config' => {
          'dbpassword' => 'changeme',
          'rootdbpassword' => 'changeme',
          'dbtype' => ENV['DBTYPE'] || 'mysql',
          'trusted_domains' => %w(localhost:8080 locahost:8443)
        }
      }
    }

    chef.run_list = %w(
      recipe[owncloud]
    )
  end

  # Enable provisioning with chef server, specifying the chef server URL, and
  # the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for ORGNAME in
  # the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be HTTP
  # instead of HTTPS depending on your configuration. Also change the validation
  # key to validation.pem.
  #
  # orgname = 'ORGNAME'
  # config.vm.provision :chef_client do |chef|
  #   chef.chef_server_url = "https://api.chef.io/organizations/#{orgname}"
  #   chef.validation_key_path = "#{orgname}-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "#{orgname}-validator"
end
