require 'openssl'

module OwnCloud
  class Certificate
    attr_reader :key, :cert

    def initialize(hostname)
      @hostname = hostname
      generate
    end

    def generate()
      # based on https://gist.github.com/nickyp/886884

      key = OpenSSL::PKey::RSA.new(2048)
      cert = OpenSSL::X509::Certificate.new
      cert.version = 2
      cert.serial = 1
      cert.subject = OpenSSL::X509::Name.parse("/CN=#{@hostname}")
      cert.issuer = cert.subject # self-signed
      cert.public_key = key.public_key
      cert.not_before = Time.now
      cert.not_after = cert.not_before + 10 * 365 * 24 * 60 * 60 # 10 years validity
      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = cert
      ef.issuer_certificate = cert
      cert.add_extension(ef.create_extension("basicConstraints", "CA:TRUE", true))
      cert.add_extension(ef.create_extension("subjectKeyIdentifier", "hash", false))
      cert.add_extension(ef.create_extension("authorityKeyIdentifier", "keyid:always,issuer:always", false))
      cert.sign(key, OpenSSL::Digest::SHA256.new)

      @cert = cert.to_pem
      @key = key.to_pem
    end
  end
end
