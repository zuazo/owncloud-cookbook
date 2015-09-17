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

require 'chef/node'
require 'cookbook_helpers'

# Class to emulate the current recipe with some helpers.
class FakeRecipe < ::Chef::Node
  include ::OwncloudCookbook::CookbookHelpers

  def initialize
    super
    name('node001')
    node = self
    Dir.glob("#{::File.dirname(__FILE__)}/../../../attributes/*.rb") do |f|
      node.from_file(f)
    end
  end
end
