# encoding: UTF-8
#
# Cookbook Name:: owncloud
# Attributes:: default
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

default['owncloud']['version'] =
  # ownCloud 8 requires PHP 5.4
  if (platform_family?('rhel') && !platform?('amazon') &&
     node['platform_version'].to_i < 7) ||
     (platform?('debian') && node['platform_version'].to_i < 7) ||
     (platform?('ubuntu') && node['platform_version'].to_i < 12)
    '7.0.4'
  else
    'latest'
  end

default['owncloud']['download_url'] =
  'http://download.owncloud.org/community/owncloud-%{version}.tar.bz2'

default['owncloud']['deploy_from_git'] = false
default['owncloud']['git_repo'] = 'https://github.com/owncloud/core.git'
default['owncloud']['git_ref'] = nil

default['owncloud']['www_dir'] = value_for_platform_family(
  %w(rhel fedora) => '/var/www/html',
  'default' => '/var/www'
)
default['owncloud']['dir'] = "#{node['owncloud']['www_dir']}/owncloud"
default['owncloud']['data_dir'] = "#{node['owncloud']['dir']}/data"
default['owncloud']['server_name'] = node['fqdn'] || 'owncloud.local'
default['owncloud']['server_aliases'] = []
default['owncloud']['install_postfix'] = true
default['owncloud']['web_server'] = 'apache'
default['owncloud']['php-fpm']['pool'] = 'owncloud'
default['owncloud']['max_upload_size'] = '512M'
default['owncloud']['sendfile'] =
  !node['virtualization'].is_a?(Hash) ||
  node['virtualization']['system'] != 'vbox'
default['owncloud']['skip_permissions'] = false

default['owncloud']['ssl'] = true

default['owncloud']['admin']['user'] = 'admin'
default['owncloud']['admin']['pass'] = nil

default['owncloud']['config']['dbtype'] = 'mysql'
default['owncloud']['config']['dbname'] = 'owncloud'
default['owncloud']['config']['dbuser'] = 'owncloud'
default['owncloud']['config']['dbpassword'] = nil
default['owncloud']['config']['dbhost'] = '127.0.0.1'
default['owncloud']['config']['dbport'] = nil
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

default['owncloud']['manage_database'] = nil

default['owncloud']['mysql']['instance'] = 'default'
default['owncloud']['mysql']['data_dir'] = nil
default['owncloud']['mysql']['run_group'] = nil
default['owncloud']['mysql']['run_user'] = nil
default['owncloud']['mysql']['version'] = nil
default['owncloud']['mysql']['server_root_password'] = nil

default['owncloud']['encrypt_attributes'] = false
