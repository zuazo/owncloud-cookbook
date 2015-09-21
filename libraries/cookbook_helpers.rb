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
  module CookbookHelpers
    def owncloud_config_file
      ::File.join(node['owncloud']['dir'], 'config', 'config.php')
    end

    def owncloud_config
      @owncloud_config ||= OwncloudCookbook::Config.new(owncloud_config_file)
    end

    def owncloud_cookbook_config
      @owncloud_cookbook_config ||= node['owncloud']['config'].to_hash
    end

    def owncloud_trusted_domains
      [
        node['owncloud']['server_name'], node['owncloud']['server_aliases']
      ].flatten
    end

    # Add server name and server aliases to trusted_domains config option.
    def calculate_trusted_domains
      unless owncloud_cookbook_config.key?('trusted_domains')
        owncloud_cookbook_config['trusted_domains'] = []
      end
      owncloud_trusted_domains.each do |domain|
        next if owncloud_cookbook_config['trusted_domains'].include?(domain)
        owncloud_cookbook_config['trusted_domains'] << domain
      end
    end

    def calculate_dbhost
      owncloud_cookbook_config['dbhost'] =
        [
          owncloud_cookbook_config['dbhost'], owncloud_cookbook_config['dbport']
        ].join(':')
    end

    def owncloud_config_update
      owncloud_config.merge(owncloud_cookbook_config)
      owncloud_config.write
      owncloud_config
    end

    # Store important options that where generated automatically by the setup.
    def save_owncloud_node_configuration
      return if Chef::Config[:solo]
      %w(passwordsalt instanceid).each do |value|
        node.set_unless['owncloud']['config'][value] = owncloud_config[value]
      end
    end

    def apply_owncloud_configuration
      calculate_trusted_domains
      calculate_dbhost
      owncloud_config_update
      save_owncloud_node_configuration
    end
  end
end
