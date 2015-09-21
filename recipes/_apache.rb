# encoding: UTF-8
#
# Cookbook Name:: owncloud
# Recipe:: _apache
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
  server_aliases node['owncloud']['server_aliases']
  port '80'
  max_upload_size node['owncloud']['max_upload_size']
  sendfile node['owncloud']['sendfile']
  enable true
end

# Enable ssl
if node['owncloud']['ssl']
  include_recipe 'apache2::mod_ssl'

  cert = ssl_certificate 'owncloud' do
    namespace node['owncloud']
    notifies :restart, 'service[apache2]'
  end

  # Create SSL virtualhost
  web_app 'owncloud-ssl' do
    template 'apache_vhost.erb'
    docroot node['owncloud']['dir']
    server_name node['owncloud']['server_name']
    server_aliases node['owncloud']['server_aliases']
    port '443'
    ssl_key cert.key_path
    ssl_cert cert.cert_path
    ssl_chain cert.chain_path
    ssl true
    max_upload_size node['owncloud']['max_upload_size']
    sendfile node['owncloud']['sendfile']
    enable true
  end
end
