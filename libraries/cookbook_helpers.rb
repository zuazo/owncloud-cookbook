# encoding: UTF-8
#
# Cookbook Name:: owncloud
# Library:: cookbook_helpers
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

# `owncloud` cookbook internal classes.
module OwncloudCookbook
  # Some helpers to use from `owncloud` cookbook recipes or resources.
  #
  # @example
  #   self.class.send(:include, OwncloudCookbook::CookbookHelpers)
  #   apply_owncloud_configuration
  module CookbookHelpers
    # Gets the ownCloud configuration file full path.
    #
    # @return [String] configuration file path.
    # @example
    #   owncloud_config_file #=> '/var/www/owncloud/config/config.php'
    # @api public
    def owncloud_config_file
      ::File.join(node['owncloud']['dir'], 'config', 'config.php')
    end

    # Returns the [OwncloudCookbook::Config] instance.
    #
    # @return [OwncloudCookbook::Config] configuration object.
    # @example
    #   owncloud_config #=> #<OwncloudCookbook::Config:0x00000001b637c0>
    # @api public
    def owncloud_config
      @owncloud_config ||= OwncloudCookbook::Config.new(owncloud_config_file)
    end

    # Gets ownCloud default configuration values.
    #
    # @return [Hash] configuration values.
    # @example
    #   owncloud_cookbook_config
    #     #=> {"dbtype"=>"mysql", "dbname"=>"owncloud", ...}
    # @api public
    def owncloud_cookbook_config
      @owncloud_cookbook_config ||= node['owncloud']['config'].to_hash
    end

    # Generates the ownCloud trusted domain list.
    #
    # Generates the domain list from the `node['owncloud']['server_name']` and
    # the `node['owncloud']['server_aliases']` attribute values.
    #
    # @return [Array] domain list.
    # @example
    #   owncloud_trusted_domains #=> ["owncloud.example.com"]
    # @api public
    def owncloud_trusted_domains
      [
        node['owncloud']['server_name'], node['owncloud']['server_aliases']
      ].flatten
    end

    # Adds server name and server aliases to trusted_domains configuration
    # option.
    #
    # Merges the generated owncloud trusted domains and the
    # `node['owncloud']['config']['trusted_domains']` attribute values.
    #
    # @return [Array] domain list.
    # @example
    #   calculate_trusted_domains
    #     #=> ["owncloud.example.com", "www.example.com"]
    # @api public
    def calculate_trusted_domains
      unless owncloud_cookbook_config.key?('trusted_domains')
        owncloud_cookbook_config['trusted_domains'] = []
      end
      owncloud_trusted_domains.each do |domain|
        next if owncloud_cookbook_config['trusted_domains'].include?(domain)
        owncloud_cookbook_config['trusted_domains'] << domain
      end
    end

    # Calculates the database host.
    #
    # @return [String] database host and port.
    # @example
    #   calculate_dbhost #=> "db.example.com:3306"
    # @api public
    def calculate_dbhost
      owncloud_cookbook_config['dbhost'] =
        [
          owncloud_cookbook_config['dbhost'], owncloud_cookbook_config['dbport']
        ].join(':')
    end

    # Updates the disk configuration values from the new calculated values.
    #
    # Merges all the configuration values.
    #
    # @return void
    # @example
    #   owncloud_config_update
    # @api public
    def owncloud_config_update
      owncloud_config.merge(owncloud_cookbook_config)
      owncloud_config.write
      owncloud_config
    end

    # Store important options that where generated automatically by the setup.
    #
    # Saves them in Chef Node attributes.
    #
    # @return void
    # @example
    #   save_owncloud_node_configuration
    # @api public
    def save_owncloud_node_configuration
      return if Chef::Config[:solo]
      %w(passwordsalt instanceid).each do |value|
        node.set_unless['owncloud']['config'][value] = owncloud_config[value]
      end
    end

    # Calculates new configuration options, merged them and save them on disk.
    #
    # - Calculates trusted domains.
    # - Calculates database host.
    # - Updates ownCloud configuration options on disk.
    # - Saves some generated options in Chef Node attributes.
    #
    # @return void
    # @example
    #   apply_owncloud_configuration
    # @api public
    def apply_owncloud_configuration
      calculate_trusted_domains
      calculate_dbhost
      owncloud_config_update
      save_owncloud_node_configuration
    end
  end
end
