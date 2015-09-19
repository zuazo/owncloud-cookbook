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

family = os[:family].downcase
apache =
  if %w(centos redhat fedora scientific amazon).include?(family)
    'httpd'
  else
    'apache2'
  end

describe 'apache' do
  describe package(apache) do
    it { should be_installed }
  end

  describe port(80) do
    it { should be_listening }
  end

  describe port(443) do
    it { should be_listening }
  end

  describe process(apache) do
    it { should be_running }
  end

  describe process('nginx') do
    it { should_not be_running }
  end

  describe server(:web) do
    describe http('/') do
      it 'runs Apache httpd' do
        expect(response['Server']).to include 'Apache'
      end
    end # http /login.php
  end # server web
end # apache
