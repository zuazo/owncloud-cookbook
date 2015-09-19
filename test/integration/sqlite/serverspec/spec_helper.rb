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

require 'serverspec'
require 'infrataster/rspec'

# Set backend type
set :backend, :exec

ENV['PATH'] = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

Infrataster::Server.define(:web, '127.0.0.1')

# Infrataster hack to ignore phantomjs SSL errors
Infrataster::Contexts::CapybaraContext.class_eval do
  def self.prepare_session
    driver = Infrataster::Contexts::CapybaraContext::CAPYBARA_DRIVER_NAME
    Capybara.register_driver driver do |app|
      Capybara::Poltergeist::Driver.new(
        app,
        phantomjs_options: %w(--ignore-ssl-errors=true)
      )
    end
    Capybara::Session.new(driver)
  end
end
