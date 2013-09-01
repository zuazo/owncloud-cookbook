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
  ssl_key_path, ssl_cert_path = generate_certificate

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
