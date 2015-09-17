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
require_relative '../support/fake_recipe'
require 'cookbook_helpers'
require 'config'

describe OwncloudCookbook::CookbookHelpers, order: :random do
  subject { FakeRecipe.new }
  let(:node) { subject.node }
  let(:config_file) { '/var/www/owncloud/config/config.php' }
  before do
    node.set['owncloud']['dir'] = '/var/www/owncloud'
    allow(::File).to receive(:exist?).and_call_original
    allow(::File).to receive(:exist?).with(config_file).and_return(false)
  end

  context '#owncloud_config_file' do
    it 'returns ownCloud configuration file' do
      expect(subject.owncloud_config_file).to eq(config_file)
    end
  end

  context '#owncloud_config' do
    it 'returns an OwncloudCookbook::Config instance' do
      expect(::File).to receive(:exist?).with(config_file).and_return(false)
      expect(subject.owncloud_config).to be_a(OwncloudCookbook::Config)
    end

    it 'passes the file path to OwncloudCookbook::Config' do
      expect(OwncloudCookbook::Config)
        .to receive(:new).once.and_return(config_file)
      subject.owncloud_config
    end
  end

  context '#owncloud_cookbook_config' do
    it 'returns a hash' do
      expect(subject.owncloud_cookbook_config).to be_instance_of(Hash)
    end

    it 'does not return a mash' do
      expect(subject.owncloud_cookbook_config).to_not be_instance_of(Mash)
    end

    it 'has the same value as node["owncloud"]["config"]' do
      expect(subject.owncloud_cookbook_config).to eq(node['owncloud']['config'])
    end

    it 'is not the same hash as node["owncloud"]["config"]' do
      expect(subject.owncloud_cookbook_config)
        .to_not equal(node['owncloud']['config'])
    end
  end # context #owncloud_cookbook_config

  context '#owncloud_trusted_domains' do
    let(:server_name) { 'servername1' }
    let(:server_aliases) { %w(serveralias1 serveralias2) }
    before do
      node.set['owncloud']['server_name'] = server_name
      node.set['owncloud']['server_aliases'] = server_aliases
    end

    it 'returns server name and server aliases' do
      expect(subject.owncloud_trusted_domains)
        .to eq(%w(servername1 serveralias1 serveralias2))
    end
  end

  context '#calculate_trusted_domains' do
    let(:server_name) { 'servername1' }
    let(:server_aliases) { %w(serveralias1 serveralias2) }
    before do
      node.set['owncloud']['server_name'] = server_name
      node.set['owncloud']['server_aliases'] = server_aliases
    end

    it 'sets owncloud trusted_domains configuration' do
      subject.calculate_trusted_domains
      expect(subject.owncloud_cookbook_config['trusted_domains'].sort)
        .to eq(%w(servername1 serveralias1 serveralias2).sort)
    end

    it 'does not duplicate domains' do
      node.set['owncloud']['config']['trusted_domains'] = [server_aliases[0]]
      subject.calculate_trusted_domains
      expect(subject.owncloud_cookbook_config['trusted_domains'].sort)
        .to eq(%w(servername1 serveralias1 serveralias2).sort)
    end
  end # context #calculate_trusted_domains

  context '#calculate_dbhost' do
    let(:dbhost) { 'mydbhost' }
    let(:dbport) { 'mydbport' }
    before do
      node.set['owncloud']['config']['dbhost'] = dbhost
      node.set['owncloud']['config']['dbport'] = dbport
    end

    it 'returns database address' do
      expect(subject.calculate_dbhost).to eq("#{dbhost}:#{dbport}")
    end
  end

  context '#owncloud_config_update' do
    let(:owncloud_config) { instance_double('OwncloudCookbook::Config') }
    before do
      allow(OwncloudCookbook::Config)
        .to receive(:new).and_return(owncloud_config)
      allow(owncloud_config).to receive(:merge)
      allow(owncloud_config).to receive(:write)
    end

    it 'merges the configuration' do
      expect(owncloud_config)
        .to receive(:merge).with(subject.owncloud_cookbook_config).once
      subject.owncloud_config_update
    end

    it 'writes the configuration' do
      expect(owncloud_config).to receive(:write).with(no_args).once
      subject.owncloud_config_update
    end

    it 'returns the owncloud configuration' do
      expect(subject.owncloud_config_update).to equal(owncloud_config)
    end
  end # context #owncloud_config_update

  context '#save_owncloud_node_configuration' do
    let(:salt) { 'salt1' }
    let(:id) { 'id1' }
    let(:owncloud_config) { instance_double('OwncloudCookbook::Config') }
    before do
      allow(OwncloudCookbook::Config)
        .to receive(:new).and_return(owncloud_config)
      allow(owncloud_config)
        .to receive(:[]).with('passwordsalt').and_return(salt)
      allow(owncloud_config).to receive(:[]).with('instanceid').and_return(id)
    end

    context 'in Chef Solo' do
      before { Chef::Config[:solo] = true }

      it 'does not save the password salt' do
        subject.save_owncloud_node_configuration
        expect(node['owncloud']['config']['passwordsalt']).to_not eq(salt)
      end

      it 'does not save the instance id' do
        subject.save_owncloud_node_configuration
        expect(node['owncloud']['config']['instanceid']).to_not eq(id)
      end
    end

    context 'in Chef Server' do
      before { Chef::Config[:solo] = false }

      it 'saves the password salt' do
        subject.save_owncloud_node_configuration
        expect(node['owncloud']['config']['passwordsalt']).to eq(salt)
      end

      it 'does not save the instance id' do
        subject.save_owncloud_node_configuration
        expect(node['owncloud']['config']['instanceid']).to eq(id)
      end
    end
  end # context #save_owncloud_node_configuration

  context '#apply_owncloud_configuration' do
    methods = %w(
      calculate_trusted_domains
      calculate_dbhost
      owncloud_config_update
      save_owncloud_node_configuration
    )
    before do
      methods.each do |meth|
        allow(subject).to receive(meth).with(no_args)
      end
    end
    after { subject.apply_owncloud_configuration }

    methods.each do |meth|
      it "calls ##{meth} method" do
        expect(subject).to receive(meth).with(no_args).once
      end
    end
  end
end
