require 'openssl'

module OwnCloud
  class Certificate

    def initialize(node)
      raise TypeError, 'Chef::Node object expected' unless node.kind_of?(Chef::Node)
      @node = node
    end

    def node
      @node
    end

    def key_path
      @key_path ||= begin
        dir = case node['platform']
        when 'debian', 'ubuntu'
          '/etc/ssl/private'
        when 'redhat', 'centos', 'fedora', 'scientific', 'amazon'
          '/etc/pki/tls/private'
        else
          node['owncloud']['www_dir']
        end
        ::File.join(dir, 'owncloud.key')
      end
    end

    def key_content
      @key_content ||= begin
        ssl_key = node['owncloud']['ssl_key']
        case ssl_key['source']
        when 'attribute'
          if ssl_key.attribute?('content') and ssl_key['content'].kind_of?(String)
            ssl_key['content']
          else
            Chef::Application.fatal!('Cannot read SSL key from attribute: node["owncloud"]["ssl_key"]["content"]')
          end
        when 'data-bag'
          read_from_data_bag(ssl_key['bag'], ssl_key['item'], ssl_key['item_key'], ssl_key['encrypted'], ssl_key['secret_file']) or
            Chef::Application.fatal!("Cannot read SSL key from data bag: #{ssl_key['bag']}.#{ssl_key['item']}->#{ssl_key['item_key']}")
        when 'chef-vault'
          read_from_chef_vault(ssl_key['bag'], ssl_key['item'], ssl_key['item_key']) or
            Chef::Application.fatal!("Cannot read SSL key from chef-vault: #{ssl_key['bag']}.#{ssl_key['item']}->#{ssl_key['item_key']}")
        when 'file'
          read_from_path(ssl_key['path']) or
            Chef::Application.fatal!("Cannot read SSL key from path: #{ssl_key['path']}")
        when 'self-signed'
          read_from_path(key_path) or generate_key
        else
          Chef::Application.fatal!("Cannot read SSL key, unknown source: #{ssl_key['source']}")
        end
      end
    end

    def cert_path
      @cert_path ||= begin
        dir = case node['platform']
        when 'debian', 'ubuntu'
          '/etc/ssl/certs'
        when 'redhat', 'centos', 'fedora', 'scientific', 'amazon'
          '/etc/pki/tls/certs'
        else
          node['owncloud']['www_dir']
        end
        ::File.join(dir, 'owncloud.pem')
      end
    end

    def cert_content
      @cert_content ||= begin
        ssl_cert = node['owncloud']['ssl_cert']
        case ssl_cert['source']
        when 'attribute'
          if ssl_cert.attribute?('content') and ssl_cert['content'].kind_of?(String)
            ssl_cert['content']
          else
            Chef::Application.fatal!('Cannot read SSL certificate from attribute: node["owncloud"]["ssl_cert"]["content"]')
          end
        when 'data-bag'
          read_from_data_bag(ssl_cert['bag'], ssl_cert['item'], ssl_cert['item_key'], ssl_cert['encrypted'], ssl_cert['secret_file']) or
            Chef::Application.fatal!("Cannot read SSL certificate from data bag: #{ssl_cert['bag']}.#{ssl_cert['item']}->#{ssl_cert['item_key']}")
        when 'chef-vault'
          read_from_chef_vault(ssl_cert['bag'], ssl_cert['item'], ssl_cert['item_key']) or
            Chef::Application.fatal!("Cannot read SSL certificate from chef-vault: #{ssl_cert['bag']}.#{ssl_cert['item']}->#{ssl_cert['item_key']}")
        when 'file'
          read_from_path(ssl_cert['path']) or
            Chef::Application.fatal!("Cannot read SSL certificate from path: #{ssl_cert['path']}")
        when 'self-signed'
          content = read_from_path(cert_path)
          unless content and verify_self_signed_cert(key_content, content, node['owncloud']['server_name'])
           content = generate_self_signed_cert(key_content, node['owncloud']['server_name'])
          end
          content
        else
          Chef::Application.fatal!("Cannot read SSL certificate, unknown source: #{ssl_cert['source']}")
        end
      end
    end

    private

    def read_from_path(path)
      if ::File.exists?(path)
        ::IO.read(path)
      end
    end

    def read_from_data_bag(bag, item, item_key, encrypted = false, secret_file = nil)
      begin
        if encrypted
          item = Chef::EncryptedDataBagItem.load(bag, item, secret_file)
        else
          item = Chef::DataBagItem.load(bag, item)
        end
        item[item_key]
      rescue
        nil
      end
    end

    def read_from_chef_vault(bag, item, item_key)
      require 'chef-vault'

      begin
        item = ChefVault::Item.load(bag, item)
        item[item_key]
      rescue
        nil
      end
    end

    def generate_key
      OpenSSL::PKey::RSA.new(2048).to_pem
    end

    def generate_self_signed_cert(key, hostname)
      # based on https://gist.github.com/nickyp/886884
      key = OpenSSL::PKey::RSA.new(key)
      cert = OpenSSL::X509::Certificate.new
      cert.version = 2
      cert.serial = 1
      cert.subject = OpenSSL::X509::Name.parse("/CN=#{hostname}")
      cert.issuer = cert.subject # self-signed
      cert.public_key = key.public_key
      cert.not_before = Time.now
      cert.not_after = cert.not_before + 10 * 365 * 24 * 60 * 60 # 10 years validity
      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = cert
      ef.issuer_certificate = cert
      cert.add_extension(ef.create_extension('basicConstraints', 'CA:TRUE', true))
      cert.add_extension(ef.create_extension('subjectKeyIdentifier', 'hash', false))
      cert.add_extension(ef.create_extension('authorityKeyIdentifier', 'keyid:always,issuer:always', false))
      cert.sign(key, OpenSSL::Digest::SHA256.new)
      cert.to_pem
    end

    def verify_self_signed_cert(key, cert, hostname)
      key = OpenSSL::PKey::RSA.new(key)
      cert = OpenSSL::X509::Certificate.new(cert)
      subject = OpenSSL::X509::Name.parse("/CN=#{hostname}")
      key.params['n'] == cert.public_key.params['n'] && cert.subject == subject && cert.issuer == subject
    end

  end
end
