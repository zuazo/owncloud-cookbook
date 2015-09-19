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

describe 'mysql' do
  describe process('mysqld') do
    it { should be_running }
  end

  describe port(3306) do
    it { should be_listening.with('tcp') }
  end

  describe server(:db) do
    describe mysql_query('SHOW DATABASES') do
      it 'includes `ownloud` database' do
        databases = results.map { |r| r['Database'] }
        expect(databases).to include('owncloud')
      end
    end
  end # server db
end # mysql
