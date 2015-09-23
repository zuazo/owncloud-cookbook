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

family = os[:family].downcase
docroot_dir =
  if %w(centos redhat fedora scientific amazon).include?(family)
    '/var/www/html'
  elsif %w(suse opensuse).include?(family)
    '/srv/www/htdocs'
  elsif %w(arch).include?(family)
    '/srv/http'
  elsif %w(freebsd).include?(family)
    '/usr/local/www/apache24/data'
  else
    '/var/www'
  end

describe 'sqlite' do
  describe file("#{docroot_dir}/owncloud/data") do
    it { should be_directory }
    it { should be_mode 750 }
  end

  describe file("#{docroot_dir}/owncloud/data/owncloud.db") do
    it { should be_file }
    it { should be_mode 644 }
  end
end # sqlite
