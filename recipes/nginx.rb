#
# Cookbook Name:: owncloud
# Recipe:: apache2
#
# Copyright 2013, Onddo Labs, Sl.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#==============================================================================
# Set up nginx webserver
#==============================================================================

include_recipe 'nginx'
node.default['php-fpm']['pool']['testpool']['listen'] = '127.0.0.1:9000'
include_recipe 'php-fpm'

# Disable default site
nginx_site 'default' do
  enable false
end

# Create virtualhost for ownCloud
template(File.join(node['nginx']['dir'], 'sites-available', 'owncloud')) do
  source 'nginx_vhost.erb'
  mode 00644
  owner 'root'
  group 'root'
  variables(
    :name => 'owncloud',
    :server_name => node['owncloud']['server_name'],
    :docroot => node['owncloud']['dir'],
    :port => 80
  )
  notifies :reload, 'service[nginx]'
end

nginx_site 'owncloud' do
  enable true
end

# SSL certs and port
if node['owncloud']['ssl']
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

  # Create virtualhost for ownCloud
  template(File.join(node['nginx']['dir'], 'sites-available', 'owncloud-ssl')) do
    source 'nginx_vhost.erb'
    mode 00644
    owner 'root'
    group 'root'
    variables(
      :name => 'owncloud-ssl',
      :server_name => node['owncloud']['server_name'],
      :docroot => node['owncloud']['dir'],
      :port => 443,
      :ssl_key => ssl_key_path,
      :ssl_cert => ssl_cert_path
    )
    notifies :reload, 'service[nginx]'
  end

  nginx_site 'owncloud-ssl' do
    enable true
  end
end
