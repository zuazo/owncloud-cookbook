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

describe 'owncloud::_nginx' do
  let(:chef_runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:node) { chef_runner.node }
  before do
    node.set['owncloud']['ssl'] = true
    stub_nginx_cookbook
    allow(::File).to receive(:exist?).and_call_original
    allow(::File).to receive(:exist?).with('/etc/init.d/apache2')
      .and_return(true)
  end

  it 'includes nginx recipe' do
    expect(chef_run).to include_recipe('nginx')
  end

  it 'includes owncloud::_php_fpm recipe' do
    expect(chef_run).to include_recipe('owncloud::_php_fpm')
  end

  it 'disables nginx default site' do
    chef_run
    expect(node['nginx']['default_site_enabled']).to eq(false)
  end

  it 'creates owncloud virtualhost' do
    expect(chef_run)
      .to create_template('/etc/nginx/sites-available/owncloud')
      .with_source('nginx_vhost.erb')
      .with_mode(00644)
      .with_owner('root')
      .with_group('root')
  end

  context 'owncloud virtualhost resource' do
    let(:resource) { chef_run.template('/etc/nginx/sites-available/owncloud') }

    it 'notifies nginx to reload' do
      expect(resource).to notify('service[nginx]').to(:reload).delayed
    end
  end

  it 'enables nginx owncloud site' do
    allow(::File).to receive(:symlink?)
      .with('/etc/nginx/sites-enabled/owncloud').and_return(false)
    expect(chef_run).to run_execute('nxensite owncloud')
  end

  context 'with SSL enabled' do
    before { node.set['owncloud']['ssl'] = true }

    it 'creates SSL certificate' do
      expect(chef_run).to create_ssl_certificate('owncloud')
    end

    context 'SSL certificate resource' do
      let(:resource) { chef_run.ssl_certificate('owncloud') }

      it 'notifies nginx to restart' do
        expect(resource).to notify('service[nginx]').to(:restart).delayed
      end
    end

    it 'creates nginx owncloud-ssl site' do
      expect(chef_run)
        .to create_template(%r{/sites-available/owncloud-ssl$})
    end

    it 'enables nginx owncloud-ssl site' do
      allow(::File).to receive(:symlink?)
        .with('/etc/nginx/sites-enabled/owncloud-ssl').and_return(false)
      expect(chef_run).to run_execute('nxensite owncloud-ssl')
    end
  end

  context 'with SSL disabled' do
    before { node.set['owncloud']['ssl'] = false }

    it 'does not create SSL certificate' do
      expect(chef_run).to_not create_ssl_certificate('owncloud')
    end

    it 'does not create nginx owncloud-ssl site' do
      expect(chef_run)
        .to_not create_template(%r{/sites-available/owncloud-ssl$})
    end

    it 'does not enable nginx owncloud-ssl site' do
      allow(::File).to receive(:symlink?)
        .with('/etc/nginx/sites-enabled/owncloud-ssl').and_return(false)
      expect(chef_run).to_not run_execute('nxensite owncloud-ssl')
    end
  end
end
