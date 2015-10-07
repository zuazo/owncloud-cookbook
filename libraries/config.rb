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
  #
  # @example
  #   config_file = '/var/www/owncloud/config/config.php'
  #   c = OwncloudCookbook::Config.new(config_file)
  #   c.merge(node['owncloud']['config'])
  #   c.write
  class Config
    # ownCloud configuration values hash.
    #
    # @private
    attr_reader :options

    # OwncloudCookbook::Config constructor.
    #
    # Reads the current configuration values.
    #
    # @param file [String] ownCloud PHP configuration file path.
    # @example
    #   config_file = '/var/www/owncloud/config/config.php'
    #   OwncloudCookbook::Config.new(config_file)
    # @api public
    def initialize(file)
      @file = file
      @options = {}
      @original_options = {}
      read
    end

    protected

    # Returns the configuration options in PHP compatible JSON format as
    # string.
    #
    # @return [String] The JSON string.
    # @example
    #   @options = Hash.new
    #   @options['key'] = "valu'e"
    #   options_php_json #=> "{\"key\":\"valu\\'e\"}"
    # @private
    def options_php_json
      @options.to_json.gsub('\\', '\\\\\\').gsub("'", "\\\\'")
    end

    # Merge two option values.
    #
    # Makes an union on array values.
    #
    # It also mantains the original dbtype when sqlite3 driver is available.
    #
    # @param key [String] configuration key name.
    # @param value1 [Mixed] the original value.
    # @param value2 [Mixed] the new value.
    # @return [Mixed] the configuration values merged.
    # @example
    #   merge_value('key', 'A', 'B') #=> "B"
    #   merge_value('array', %w(1 2), %w(2 3)) #=> ["1", "2", "3"]
    #   merge_value('dbtype', 'sqlite3', 'sqlite') #=> "sqlite3"
    # @private
    def merge_value(key, value1, value2)
      if value1.is_a?(Array) && value2.is_a?(Array)
        value1 | value2
      elsif key == 'dbtype' && value1 == 'sqlite3' && value2 == 'sqlite'
        value1
      else
        value2
      end
    end

    public

    # Gets an option value.
    #
    # @param index [Mixed] option name.
    # @return [Mixed] option value.
    # @example
    #   config_file = '/var/www/owncloud/config/config.php'
    #   c = OwncloudCookbook::Config.new(config_file)
    #   c['dbtype'] #=> 'mysql'
    # @api public
    def [](index)
      @options[index]
    end

    # Merges new configuration options with the current values.
    #
    # Saves the merged configuration values internally in an accumulator
    # variable but not on disk.
    #
    # @param new_options [Hash] New configuration values.
    # @return [Hash] Merged configuration values.
    # @example
    #   config_file = '/var/www/owncloud/config/config.php'
    #   c = OwncloudCookbook::Config.new(config_file)
    #   c.merge(node['owncloud']['config'])
    #     #=> {"dbtype"=>"mysql", "dbname"=>"owncloud", ...}
    # @api public
    def merge(new_options)
      return unless new_options.respond_to?(:to_hash)
      new_options = new_options.to_hash
      # remove not set values
      new_options.reject! { |_k, v| v.nil? }
      # merge options overriding collisions with new values
      @options.merge!(new_options) { |k, v1, v2| merge_value(k, v1, v2) }
    end

    # Reads the current configuration values from disk.
    #
    # Saves the read configuration values internally in an accumulator
    # variable.
    #
    # @return [Hash] Configuration values.
    # @example
    #   config_file = '/var/www/owncloud/config/config.php'
    #   c = OwncloudCookbook::Config.new(config_file)
    #   c.read #=> {"dbtype"=>"mysql", "dbname"=>"owncloud", ...}
    # @api public
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

    # Writes the accumulated configuration values to disk.
    #
    # @return void
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
