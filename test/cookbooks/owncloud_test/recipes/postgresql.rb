# encoding: UTF-8
#
# Cookbook Name:: owncloud_test
# Recipe:: postgresql
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

node.set['postgresql']['password']['postgres'] = 'vagrant_postgres'

node.set['owncloud']['config']['dbpassword'] = 'database_pass'
node.default['owncloud']['config']['dbtype'] = 'pgsql'

include_recipe 'owncloud_test::postgresql_memory'

include_recipe 'owncloud_test::common'
