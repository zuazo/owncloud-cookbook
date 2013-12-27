
default['owncloud']['version'] = 'latest'
default['owncloud']['download_url'] = "http://download.owncloud.org/community/owncloud-#{node['owncloud']['version']}.tar.bz2"

default['owncloud']['deploy_from_git'] = false
default['owncloud']['git_repo'] = 'https://github.com/owncloud/core.git'
default['owncloud']['git_ref'] = nil

default['owncloud']['www_dir'] = value_for_platform_family(
  ['rhel', 'fedora'] => '/var/www/html',
  'default' => '/var/www',
)
default['owncloud']['dir'] = "#{node['owncloud']['www_dir']}/owncloud"
default['owncloud']['data_dir'] = "#{node['owncloud']['dir']}/data"
default['owncloud']['server_name'] = node['fqdn']
default['owncloud']['server_aliases'] = [ 'localhost' ] # required by http_request[run setup]
default['owncloud']['install_postfix'] = true
default['owncloud']['web_server'] = 'apache'
default['owncloud']['php-fpm']['pool'] = 'owncloud'
default['owncloud']['max_upload_size'] = '512M'

default['owncloud']['ssl'] = true
case node['platform']
when 'debian', 'ubuntu'
  default['owncloud']['ssl_key_dir'] = '/etc/ssl/private'
  default['owncloud']['ssl_cert_dir'] = '/etc/ssl/certs'
when 'redhat', 'centos', 'fedora', 'scientific', 'amazon'
  default['owncloud']['ssl_key_dir'] = '/etc/pki/tls/private'
  default['owncloud']['ssl_cert_dir'] = '/etc/pki/tls/certs'
else
  default['owncloud']['ssl_key_dir'] = node['owncloud']['www_dir']
  default['owncloud']['ssl_cert_dir'] = node['owncloud']['www_dir']
end

default['owncloud']['admin']['user'] = 'admin'
default['owncloud']['admin']['pass'] = nil

default['owncloud']['config']['dbtype'] = 'mysql'
default['owncloud']['config']['dbname'] = 'owncloud'
default['owncloud']['config']['dbuser'] = 'owncloud'
default['owncloud']['config']['dbpassword'] = nil
default['owncloud']['config']['dbhost'] = 'localhost'
default['owncloud']['config']['dbtableprefix'] = ''

default['owncloud']['config']['mail_smtpmode'] = 'sendmail'
default['owncloud']['config']['mail_smtphost'] = '127.0.0.1'
default['owncloud']['config']['mail_smtpport'] = 25
default['owncloud']['config']['mail_smtptimeout'] = 10
default['owncloud']['config']['mail_smtpsecure'] = ''
default['owncloud']['config']['mail_smtpauth'] = false
default['owncloud']['config']['mail_smtpauthtype'] = 'LOGIN'
default['owncloud']['config']['mail_smtpname'] = ''
default['owncloud']['config']['mail_smtppassword'] = ''

default['owncloud']['cron']['enabled'] = true
default['owncloud']['cron']['min'] = '*/15'
default['owncloud']['cron']['day'] = '*'
default['owncloud']['cron']['hour'] = '*'
default['owncloud']['cron']['month'] = '*'
default['owncloud']['cron']['weekday'] = '*'
