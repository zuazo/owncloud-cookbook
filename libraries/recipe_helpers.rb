
module OwnCloud
  module RecipeHelpers

    def generate_certificate

      # install needed dependencies
      if node['owncloud']['ssl_key']['source'] == 'chef-vault' ||
        node['owncloud']['ssl_cert']['source'] == 'chef-vault'
        chef_gem 'chef-vault'
      end

      cert = OwnCloud::Certificate.new(node)

      # Create ssl certificate key
      file 'owncloud.key' do
        path cert.key_path
        owner 'root'
        group 'root'
        mode 00600
        content cert.key_content
        action :create
      end

      # Create ssl certificate
      file 'owncloud.pem' do
        path cert.cert_path
        owner 'root'
        group 'root'
        mode 00644
        content cert.cert_content
        action :create
      end

      [ cert.key_path, cert.cert_path ]
    end

  end
end
