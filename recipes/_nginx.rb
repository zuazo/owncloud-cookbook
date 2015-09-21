# encoding: UTF-8
#
# Cookbook Name:: owncloud
# Recipe:: _nginx
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2015 Xabier de Zuazo
# Copyright:: Copyright (c) 2013-2015 Onddo Labs, SL.
# License:: Apache License, Version 2.0
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

include_recipe 'nginx'
include_recipe 'owncloud::_php_fpm'

# Disable default site
nginx_site 'default' do
  enable false
end

fastcgi_pass =
  "unix:/var/run/php-fpm-#{node['owncloud']['php-fpm']['pool']}.sock"

# Create virtualhost for ownCloud
template File.join(node['nginx']['dir'], 'sites-available', 'owncloud') do
  source 'nginx_vhost.erb'
  mode 00644
  owner 'root'
  group 'root'
  variables(
    name: 'owncloud',
    server_name: node['owncloud']['server_name'],
    server_aliases: node['owncloud']['server_aliases'],
    docroot: node['owncloud']['dir'],
    port: 80,
    fastcgi_pass: fastcgi_pass,
    max_upload_size: node['owncloud']['max_upload_size'],
    sendfile: node['owncloud']['sendfile']
  )
  notifies :reload, 'service[nginx]'
end

nginx_site 'owncloud' do
  enable true
end

# SSL certs and port
if node['owncloud']['ssl']
  cert = ssl_certificate 'owncloud' do
    namespace node['owncloud']
    notifies :restart, 'service[nginx]' # TODO: reload?
  end

  # Create virtualhost for ownCloud
  template File.join(node['nginx']['dir'], 'sites-available', 'owncloud-ssl') do
    source 'nginx_vhost.erb'
    mode 00644
    owner 'root'
    group 'root'
    variables(
      name: 'owncloud-ssl',
      server_name: node['owncloud']['server_name'],
      server_aliases: node['owncloud']['server_aliases'],
      docroot: node['owncloud']['dir'],
      port: 443,
      fastcgi_pass: fastcgi_pass,
      ssl_key: cert.key_path,
      ssl_cert: cert.chain_combined_path,
      ssl: true,
      max_upload_size: node['owncloud']['max_upload_size'],
      sendfile: node['owncloud']['sendfile']
    )
    notifies :reload, 'service[nginx]'
  end

  nginx_site 'owncloud-ssl' do
    enable true
  end
end
