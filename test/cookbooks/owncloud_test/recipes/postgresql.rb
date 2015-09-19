#
# Cookbook Name:: owncloud_test
# Recipe:: postgresql
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

if node['platform_family'] == 'debian'
  # Debian/Ubuntu requires locale cookbook:
  # https://github.com/hw-cookbooks/postgresql/issues/108
  ENV['LANGUAGE'] = ENV['LANG'] = node['locale']['lang']
  ENV['LC_ALL'] = node['locale']['lang']
  include_recipe 'locale'
end

node.default['owncloud']['database']['rootpassword'] = 'vagrant_postgres'

node.default['owncloud']['config']['dbpassword'] = 'database_pass'
node.default['owncloud']['config']['dbtype'] = 'pgsql'

include_recipe 'owncloud_test::postgresql_memory'

include_recipe 'owncloud_test::common'

# Required for integration tests:
include_recipe 'nokogiri'
