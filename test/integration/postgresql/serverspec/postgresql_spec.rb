# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2015 Xabier de Zuazo
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

require_relative 'spec_helper'
require 'json'

# Checks if we are on CentOS.
#
# @return [Boolean] whether we are in CentOS.
# @example
#   centos? #=> true
def centos?
  File.exist?('/etc/centos-release')
end

family = os[:family].downcase
release = os[:release].to_i

postgres =
  if %w(centos redhat scientific amazon).include?(family)
    if centos? && release >= 7
      'postgres'
    else
      'postmaster'
    end
  else
    'postgres'
  end

describe 'postgresql' do
  describe process(postgres) do
    it { should be_running }
  end

  describe port(5432) do
    it { should be_listening.with('tcp') }
  end

  # Issue https://github.com/hw-cookbooks/postgresql/issues/212
  # /usr/lib/libpq.so: undefined reference to `[...]@OPENSSL_1.0.0'
  # describe server(:db) do
  #   describe pgsql_query('SELECT * from pg_stat_activity') do
  #     it 'allows connection' do
  #       connection.status.should == PG::CONNECTION_OK
  #     end

  #     it 'shows database name' do
  #       row = result.find { |r| r['usename'] == 'postgres' }
  #       expect(row['datname']).to be == 'postgres'
  #     end
  #   end

  #   describe pgsql_query('SELECT datname from pg_database') do
  #     it 'allows connection' do
  #       connection.status.should == PG::CONNECTION_OK
  #     end

  #     it 'includes `owncloud` database' do
  #       databases = result.map { |r| r['datname'] }
  #       expect(databases).to include('owncloud')
  #     end
  #   end
  # end # server db
end # postgresql
