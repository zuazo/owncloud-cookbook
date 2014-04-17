# -*- mode: ruby -*-
# vi: set ft=ruby :

# requires vagrant-berkshelf and vagrant-omnibus plugins

Vagrant.configure("2") do |config|
  config.vm.hostname = "owncloud.local"

  config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 443, host: 8443

  config.vm.boot_timeout = 120

  config.vm.provider "virtualbox" do |v|
    v.memory = 512
  end

  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
      "recipe[owncloud::default]"
    ]
    chef.json = {
      "mysql" => {
        "server_root_password" => "changeme",
        "server_repl_password" => "changeme",
        "server_debian_password" => "changeme"
      },
      "postgresql" => {
        "password" => {
          "postgres" => "changeme"
        }
      },
      "owncloud" => {
        "admin" => {
          "pass" => "changeme"
        },
        "config" => {
          "dbpassword" => "changeme",
          "dbtype" => ENV["DBTYPE"] || "mysql",
          "trusted_domains" => [ "localhost:8080", "locahost:8443" ]
        }
      }
    }
  end
end
