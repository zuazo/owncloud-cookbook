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

require_relative 'spec_helper'

describe 'owncloud email test' do
  describe server(:web) do
    describe http('http://127.0.0.1/emailtest.php') do
      it 'returns OK status' do
        expect(response.status).to eq 200
      end

      it 'sends an email' do
        sleep(1)
        spool_file =
          if ::File.exist?('/var/spool/mail/root')
            '/var/spool/mail/root'
          else
            '/var/spool/mail/vagrant'
          end
        expect(file(spool_file).content).to contain('kitchen-test@')
      end
    end # http /emailtest.php
  end # server web
end # owncloud
