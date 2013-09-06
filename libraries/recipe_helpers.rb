
module OwnCloud
  module RecipeHelpers

    def generate_certificate
      cert = OwnCloud::Certificate.new(node['owncloud']['server_name'])
      ssl_key_path = ::File.join(node['owncloud']['ssl_key_dir'], 'owncloud.key')
      ssl_cert_path = ::File.join(node['owncloud']['ssl_cert_dir'], 'owncloud.pem')

      # Create ssl certificate key
      file 'owncloud.key' do
        path ssl_key_path
        owner 'root'
        group 'root'
        mode 00600
        content cert.key
        action :create_if_missing
        notifies :create, 'file[owncloud.pem]', :immediately
      end

      # Create ssl certificate
      file 'owncloud.pem' do
        path ssl_cert_path
        owner 'root'
        group 'root'
        mode 00644
        content cert.cert
        action :nothing
      end

      [ ssl_key_path, ssl_cert_path ]
    end

  end
end
