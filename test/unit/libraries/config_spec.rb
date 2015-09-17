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
require 'config.rb'

describe OwncloudCookbook::Config, order: :random do
  let(:data_dir) { ::File.join(::File.dirname(__FILE__), '..', 'data') }
  let(:file_path) { 'file.php' }
  let(:config) { described_class.new(file_path) }
  before do
    allow(::File).to receive(:exist?).and_call_original
    allow(::File).to receive(:exist?).with(file_path).and_return(false)
  end

  context '#initialize' do
    before { allow_any_instance_of(described_class).to receive(:read) }

    it 'creates an instance of the class' do
      expect(config).to be_a(described_class)
    end

    it 'reads the configuration file' do
      expect_any_instance_of(described_class).to receive(:read).once
      config
    end
  end

  context '#[]' do
    let(:options) { Mash.new('key1' => 'value1') }
    before { config.merge(options) }

    it 'returns existing key values' do
      expect(config['key1']).to eq('value1')
    end

    it 'returns nill for non-existing keys' do
      expect(config['nonexisting']).to be_nil
    end
  end

  context '#merge' do
    it 'sets options' do
      options = Mash.new('key1' => 'value1')
      config.merge(options)
      expect(config.options).to eq(options)
    end

    it 'ignores non-hash argument' do
      config.merge('bad-arg')
      expect(config.options).to eq(Mash.new)
    end

    it 'replaces hash values' do
      orig_options = Mash.new('key1' => 'orig')
      new_options = Mash.new('key1' => 'new')
      config.merge(orig_options)
      config.merge(new_options)
      expect(config.options).to eq('key1' => 'new')
    end

    it 'merges hashes' do
      orig_options = Mash.new('key1' => ['array', 1])
      new_options = Mash.new('key2' => '2')
      config.merge(orig_options)
      config.merge(new_options)
      expect(config.options).to eq('key1' => ['array', 1], 'key2' => '2')
    end

    it 'merges arrays' do
      orig_options = Mash.new('key1' => ['array', 1])
      new_options = Mash.new('key1' => ['array1'])
      config.merge(orig_options)
      config.merge(new_options)
      expect(config.options).to eq('key1' => ['array', 1, 'array1'])
    end

    it 'merges hash of arrays' do
      orig_options = Mash.new('key1' => ['array', 1], 'key2' => '2')
      new_options = Mash.new('key1' => ['array1'], 'key3' => '3')
      config.merge(orig_options)
      config.merge(new_options)
      expect(config.options).to eq(
        'key1' => ['array', 1, 'array1'],
        'key2' => '2',
        'key3' => '3'
      )
    end

    it 'mantains original dbtype when sqlite3 driver is available' do
      orig_options = Mash.new('dbtype' => 'sqlite3')
      new_options = Mash.new('dbtype' => 'sqlite')
      config.merge(orig_options)
      config.merge(new_options)
      expect(config.options).to eq('dbtype' => 'sqlite3')
    end
  end

  context '#read' do
    let(:file_path) { ::File.join(data_dir, 'config.sample.php') }
    let(:json_file_path) { ::File.join(data_dir, 'config.sample.json') }
    let(:json) { IO.read(json_file_path) }
    let(:popen) { instance_double('IO') }
    let(:popen_read_erb) { 'config.sample.popen-read.php.erb' }
    let(:popen_read_path) { ::File.join(data_dir, popen_read_erb) }
    let(:popen_read_template) { IO.read(popen_read_path) }
    let(:popen_read) do
      eruby = Erubis::Eruby.new(popen_read_template)
      eruby.result(file: file_path)
    end
    before do
      allow(::File).to receive(:exist?).with(file_path).and_return(true)
      allow(IO).to receive(:popen).and_call_original
      allow(IO).to receive(:popen).with('php', 'r+').and_return(popen)
      allow(popen).to receive(:write)
      allow(popen).to receive(:close_write)
      allow(popen).to receive(:read).and_return(json)
      allow(popen).to receive(:close)
    end

    it 'opens php process' do
      expect(IO).to receive(:popen).with('php', 'r+').and_return(popen).once
      config # #config calls #read internally
    end

    it 'runs the correct PHP code' do
      expect(popen).to receive(:read).with(no_args).once.and_return(json)
      expect(popen).to receive(:write).with(popen_read).once
      config # #config calls #read internally
    end

    it 'raises an exception on error' do
      allow(popen).to receive(:read).with(no_args).once.and_return('bad-json')
      expect { config }.to raise_error(/Error reading ownCloud configuration/)
    end
  end # context #read

  context '#write' do
    let(:file_path) { ::File.join(data_dir, 'config.sample.php') }
    let(:json_file_path) { ::File.join(data_dir, 'config.sample.json') }
    let(:json) { IO.read(json_file_path) }
    let(:popen) { instance_double('IO') }
    let(:popen_write_file) { 'config.sample.popen-write.php' }
    let(:popen_write_path) { ::File.join(data_dir, popen_write_file) }
    let(:popen_write) { IO.read(popen_write_path) }
    let(:popen) { instance_double('IO') }
    let(:file_write_file) { 'config.sample.after-write.php' }
    let(:file_write_path) { ::File.join(data_dir, file_write_file) }
    let(:file_write) { IO.read(file_write_path) }
    let(:file) { double('File') }
    let(:new_options) { { 'key1' => 'value1', 'key2' => "quo'e" } }
    before do
      allow(::File).to receive(:exist?).with(file_path).and_return(true)
      allow(IO).to receive(:popen).and_call_original
      allow(IO).to receive(:popen).with('php', 'r+').and_return(popen)
      allow(popen).to receive(:write)
      allow(popen).to receive(:close_write)
      allow(popen).to receive(:read).and_return(json)
      allow(popen).to receive(:close)
      allow(::File).to receive(:open).and_call_original
      allow(::File).to receive(:open).with(file_path, 'w').and_yield(file)
      allow(file).to receive(:write)
      config # #config calls #read internally
    end

    it 'does not write if no new options' do
      expect(IO).to_not receive(:popen).with('php', 'r+')
      expect(file).to_not receive(:write)
      config.write
    end

    it 'opens php process' do
      config.merge(new_options)
      expect(IO).to receive(:popen).with('php', 'r+').and_return(popen).once
      config.write
    end

    it 'runs the correct PHP code' do
      config.merge(new_options)
      expect(popen).to receive(:write).with(popen_write).once
      config.write
    end

    it 'writes the correct configuration' do
      config.merge(new_options)
      expect(file).to receive(:write).with(file_write).once
      config.write
    end

    it 'raises an exception on error' do
      config.merge(new_options)
      allow(file).to receive(:write).with(file_write).and_raise('Test error')
      expect { config.write }
        .to raise_error(/Error writing ownCloud configuration/)
    end
  end # context #write
end
