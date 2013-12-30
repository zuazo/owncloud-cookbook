#
# Cookbook Name:: owncloud
# Recipe:: _nginx
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
include_recipe 'owncloud::_php_fpm'

# Disable default site
nginx_site 'default' do
  enable false
end

fastcgi_pass = "unix:/var/run/php-fpm-#{node['owncloud']['php-fpm']['pool']}.sock"

# Create virtualhost for ownCloud
template File.join(node['nginx']['dir'], 'sites-available', 'owncloud') do
  source 'nginx_vhost.erb'
  mode 00644
  owner 'root'
  group 'root'
  variables(
    :name => 'owncloud',
    :server_name => node['owncloud']['server_name'],
    :server_aliases => node['owncloud']['server_aliases'],
    :docroot => node['owncloud']['dir'],
    :port => 80,
    :fastcgi_pass => fastcgi_pass,
    :max_upload_size => node['owncloud']['max_upload_size']
  )
  notifies :reload, 'service[nginx]'
end

nginx_site 'owncloud' do
  enable true
end

# SSL certs and port
if node['owncloud']['ssl']
  ssl_key_path, ssl_cert_path = generate_certificate

  # Create virtualhost for ownCloud
  template File.join(node['nginx']['dir'], 'sites-available', 'owncloud-ssl') do
    source 'nginx_vhost.erb'
    mode 00644
    owner 'root'
    group 'root'
    variables(
      :name => 'owncloud-ssl',
      :server_name => node['owncloud']['server_name'],
      :server_aliases => node['owncloud']['server_aliases'],
      :docroot => node['owncloud']['dir'],
      :port => 443,
      :fastcgi_pass => fastcgi_pass,
      :ssl_key => ssl_key_path,
      :ssl_cert => ssl_cert_path,
      :max_upload_size => node['owncloud']['max_upload_size']
    )
    notifies :reload, 'service[nginx]'
  end

  nginx_site 'owncloud-ssl' do
    enable true
  end
end
