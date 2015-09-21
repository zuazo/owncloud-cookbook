# encoding: UTF-8
#
# Cookbook Name:: owncloud
# Library:: config
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

require 'json'

# `owncloud` cookbook internal classes.
module OwncloudCookbook
  # Class to read and write ownCloud configuration file.
  class Config
    attr_reader :options

    def initialize(file)
      @file = file
      @options = {}
      @original_options = {}
      read
    end

    protected

    def options_php_json
      @options.to_json.gsub('\\', '\\\\\\').gsub("'", "\\\\'")
    end

    def merge_value(key, value1, value2)
      # make an union on array values
      if value1.is_a?(Array) && value2.is_a?(Array)
        value1 | value2
      # exotic case: mantain original dbtype when sqlite3 driver is available
      elsif key == 'dbtype' && value1 == 'sqlite3' && value2 == 'sqlite'
        value1
      else
        value2
      end
    end

    public

    def [](index)
      @options[index]
    end

    def merge(new_options)
      return unless new_options.respond_to?(:to_hash)
      new_options = new_options.to_hash
      # remove not set values
      new_options.reject! { |_k, v| v.nil? }
      # merge options overriding collisions with new values
      @options.merge!(new_options) { |k, v1, v2| merge_value(k, v1, v2) }
    end

    def read
      return unless ::File.exist?(@file)
      f = IO.popen('php', 'r+')
      f.write "<?php require('#{@file}'); echo json_encode($CONFIG);\n"
      f.close_write
      data = f.read
      f.close
      @options = JSON.parse(data)
      @original_options = @options.clone
    rescue StandardError => e
      raise "Error reading ownCloud configuration: #{e.message}"
    end

    def write
      return if @options == @original_options
      f = IO.popen('php', 'r+')
      f.write "<?php var_export(json_decode('#{options_php_json}', true));\n"
      f.close_write
      data = f.read
      f.close
      File.open(@file, 'w') { |of| of.write "<?php\n$CONFIG = #{data};\n" }
      Chef::Log.info('OwnCloud config writen')
    rescue StandardError => e
      raise "Error writing ownCloud configuration: #{e.message}"
    end
  end
end
