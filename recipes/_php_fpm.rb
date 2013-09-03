#
# Cookbook Name:: owncloud
# Recipe:: _php_fpm
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
# Installs PHP-FPM
#==============================================================================

node.default['php-fpm']['pool']['testpool']['listen'] = '127.0.0.1:9000'
web_server = node['owncloud']['web_server']
node.default['php-fpm']['pool']['www']['user'] = node[web_server]['user']
node.default['php-fpm']['pool']['testpool']['user'] = node[web_server]['user']
node.default['php-fpm']['pool']['www']['group'] = node[web_server]['group']
node.default['php-fpm']['pool']['testpool']['group'] = node[web_server]['group']
include_recipe 'php-fpm'
