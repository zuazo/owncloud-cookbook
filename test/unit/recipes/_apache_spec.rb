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

require_relative '../spec_helper'

describe 'owncloud::_apache' do
  let(:chef_runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:node) { chef_runner.node }
  before { stub_command('/usr/sbin/apache2 -t').and_return(true) }

  it 'includes apache2::default recipe' do
    expect(chef_run).to include_recipe('apache2::default')
  end

  it 'includes apache2::mod_php5 recipe' do
    expect(chef_run).to include_recipe('apache2::mod_php5')
  end

  context 'apache_site default definition' do
    it 'disables default site' do
      allow(::File).to receive(:symlink?).and_call_original
      allow(::File).to receive(:symlink?)
        .with(%r{sites-enabled/default\.conf$}).and_return(true)
      expect(chef_run).to run_execute('a2dissite default.conf')
    end
  end

  context 'web_app owncloud definition' do
    it 'creates apache2 site' do
      expect(chef_run)
        .to create_template(%r{/sites-available/owncloud\.conf$})
    end
  end

  context 'with SSL enabled' do
    before { node.set['owncloud']['ssl'] = true }

    it 'creates SSL certificate' do
      expect(chef_run).to create_ssl_certificate('owncloud')
    end

    context 'SSL certificate resource' do
      let(:resource) { chef_run.ssl_certificate('owncloud') }

      it 'notifies apache service to restart' do
        expect(resource).to notify('service[apache2]').to(:restart).delayed
      end
    end

    context 'web_app owncloud-ssl definition' do
      it 'creates apache2 site' do
        expect(chef_run)
          .to create_template(%r{/sites-available/owncloud-ssl\.conf$})
      end
    end
  end

  context 'with SSL disabled' do
    before { node.set['owncloud']['ssl'] = false }

    it 'does not create SSL certificate' do
      expect(chef_run).to_not create_ssl_certificate('owncloud')
    end

    context 'web_app owncloud-ssl definition' do
      it 'does not create apache2 site' do
        expect(chef_run)
          .to_not create_template(%r{/sites-available/owncloud-ssl\.conf$})
      end
    end
  end
end
