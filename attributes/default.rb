
default['owncloud']['version'] = '5.0.7'
default['owncloud']['download_url'] = "http://download.owncloud.org/community/owncloud-#{node['owncloud']['version']}.tar.bz2"

default['owncloud']['www_dir'] = '/var/www'
default['owncloud']['dir'] = "#{node['owncloud']['www_dir']}/owncloud"
default['owncloud']['data_dir'] = "#{node['owncloud']['dir']}/data"
default['owncloud']['server_name'] = node['fqdn']
default['owncloud']['ssl'] = true

default['owncloud']['admin']['user'] = 'admin'
default['owncloud']['admin']['pass'] = nil

default['owncloud']['database']['type'] = 'mysql'
default['owncloud']['database']['name'] = 'owncloud'
default['owncloud']['database']['user'] = 'owncloud'
default['owncloud']['database']['pass'] = nil
default['owncloud']['database']['host'] = 'localhost'
default['owncloud']['database']['prefix'] = ''
