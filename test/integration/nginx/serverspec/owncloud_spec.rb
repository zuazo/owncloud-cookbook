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
require 'json'

describe 'owncloud' do
  describe server(:web) do
    describe http('http://127.0.0.1/') do
      it 'returns ownCloud text' do
        expect(response.body).to include('ownCloud')
      end
    end # http /

    describe http('http://127.0.0.1/status.php') do
      let(:body_json) { JSON.parse(response.body) }

      it 'returns a JSON body' do
        expect { body_json }.to_not raise_error
      end

      it 'is installed' do
        expect(body_json['installed']).to eq(true)
      end
    end # http /status.php

    describe http('https://127.0.0.1/', ssl: { verify: false }) do
      it 'returns ownCloud text' do
        expect(response.body).to include('ownCloud')
      end
    end # https /

    describe http('http://127.0.0.1/ocs/v1.php/privatedata/getattribute') do
      it 'returns 401 status' do
        expect(response.status).to eq 401
      end

      it 'returns unauthorised message' do
        expect(response.body).to include('<message>Unauthorised</message>')
      end
    end # https /ocs/v1.php/privatedata/getattribute unauthorised

    describe http(
      'http://127.0.0.1/ocs/v1.php/privatedata/getattribute',
      basic_auth: %w(test test)
    ) do
      it 'returns OK status' do
        expect(response.body).to include('<status>ok</status>')
      end
    end # https /ocs/v1.php/privatedata/getattribute with basic auth
  end # server web
end # owncloud
