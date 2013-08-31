#
# Cookbook Name:: owncloud
# Recipe:: apache
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
# Set up Apache httpd webserver
#==============================================================================

include_recipe 'apache2::default'
include_recipe 'apache2::mod_php5'

# Disable default site
apache_site 'default' do
  enable false
end

# Create virtualhost for ownCloud
web_app 'owncloud' do
  template 'apache_vhost.erb'
  docroot node['owncloud']['dir']
  server_name node['owncloud']['server_name']
  port '80'
  enable true
end

# Enable ssl
if node['owncloud']['ssl']
  include_recipe 'apache2::mod_ssl'

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

  # Create SSL virtualhost
  web_app 'owncloud-ssl' do
    template 'apache_vhost.erb'
    docroot node['owncloud']['dir']
    server_name node['owncloud']['server_name']
    port '443'
    ssl_key ssl_key_path
    ssl_cert ssl_cert_path
    enable true
  end
end
