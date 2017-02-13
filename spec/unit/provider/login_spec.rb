################################################################################
# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

require 'spec_helper'
require_relative '../../../lib/puppet/provider/login.rb'

describe 'login', unit: true do
  context 'given the OneView authentication' do
    let(:auth_settings) do
      {
        url:              'https://172.16.100.185',
        token:            'NzA3OTg2NjM2NTk21xd-TkijbSwOjm2AvXDAL4LPG49D9K8u',
        user:             'administrator',
        password:         'secret123',
        ssl_enabled:      true,
        api_version:      300,
        log_level:        'debug',
        hardware_variant: 'Synergy'
      }
    end

    let(:json_file) do
      File.read('spec/support/fixtures/unit/provider/login_oneview.json')
    end

    it 'should load configuration from file' do
      allow(ENV).to receive(:[]).with('ONEVIEW_AUTH_FILE').and_return(nil)
      allow(ENV).to receive(:[]).with('ONEVIEW_URL').and_return(nil)
      allow(File).to receive(:read).and_return(json_file)

      expect(login).to eq auth_settings
    end

    it 'should load file set in environment variable' do
      allow(ENV).to receive(:[]).with('ONEVIEW_AUTH_FILE').and_return('login_oneview_appliance.json')
      allow(ENV).to receive(:[]).with('ONEVIEW_URL').and_return(nil)
      allow(File).to receive(:read).and_return(json_file)

      expect(login).to eq auth_settings
    end

    it 'should load settings from environment variables' do
      allow(ENV).to receive(:[]).with('ONEVIEW_AUTH_FILE').and_return(nil)
      allow(ENV).to receive(:[]).with('ONEVIEW_URL').and_return('https://172.16.100.185')
      allow(ENV).to receive(:[]).with('ONEVIEW_SSL_ENABLED').and_return('true')
      allow(ENV).to receive(:[]).with('ONEVIEW_LOG_LEVEL').and_return('debug')
      allow(ENV).to receive(:[]).with('ONEVIEW_API_VERSION').and_return(300)
      allow(ENV).to receive(:[]).with('ONEVIEW_TOKEN').and_return('NzA3OTg2NjM2NTk21xd-TkijbSwOjm2AvXDAL4LPG49D9K8u')
      allow(ENV).to receive(:[]).with('ONEVIEW_USER').and_return('administrator')
      allow(ENV).to receive(:[]).with('ONEVIEW_PASSWORD').and_return('secret123')
      allow(ENV).to receive(:[]).with('ONEVIEW_HARDWARE_VARIANT').and_return('Synergy')

      expect(login).to eq auth_settings
    end

    it 'should load settings from environment variables with default values' do
      allow(ENV).to receive(:[]).with('ONEVIEW_AUTH_FILE').and_return(nil)
      allow(ENV).to receive(:[]).with('ONEVIEW_URL').and_return('https://172.16.100.185')
      allow(ENV).to receive(:[]).with('ONEVIEW_SSL_ENABLED').and_return('false')
      allow(ENV).to receive(:[]).with('ONEVIEW_LOG_LEVEL').and_return(nil)
      allow(ENV).to receive(:[]).with('ONEVIEW_API_VERSION').and_return(nil)
      allow(ENV).to receive(:[]).with('ONEVIEW_TOKEN').and_return(nil)
      allow(ENV).to receive(:[]).with('ONEVIEW_USER').and_return(nil)
      allow(ENV).to receive(:[]).with('ONEVIEW_PASSWORD').and_return(nil)
      allow(ENV).to receive(:[]).with('ONEVIEW_HARDWARE_VARIANT').and_return(nil)

      auth_settings = {
        url:               'https://172.16.100.185',
        ssl_enabled:       false,
        log_level:         'info',
        api_version:       200,
        token:             nil,
        user:              nil,
        password:          nil,
        hardware_variant:  'C7000'
      }
      expect(login).to eq auth_settings
    end

    it 'should raise error when authentication settings undefined' do
      allow(ENV).to receive(:[]).with('ONEVIEW_AUTH_FILE').and_return(nil)
      allow(ENV).to receive(:[]).with('ONEVIEW_URL').and_return(nil)

      expect { login }.to raise_error(/The OneView credentials could not be set. Please check the documentation for more information./)
    end
  end

  context 'given the Image Streamer authentication' do
    let(:auth_settings) do
      {
        url:              'https://172.16.100.182',
        token:            'NzA3OTg2NjM2NTk21xd-TkijbSwOjm2AvXDAL4LPG49D9K8u',
        ssl_enabled:      true,
        api_version:      300,
        log_level:        'debug',
        hardware_variant: 'Synergy'
      }
    end

    let(:json_file) do
      File.read('spec/support/fixtures/unit/provider/login_image_streamer.json')
    end

    it 'should load configuration from file' do
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_AUTH_FILE').and_return(nil)
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_URL').and_return(nil)
      allow(File).to receive(:read).and_return(json_file)

      expect(login_image_streamer).to eq auth_settings
    end

    it 'should load file set in environment variable' do
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_AUTH_FILE').and_return('login_image_streamer.json')
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_URL').and_return(nil)
      allow(File).to receive(:read).and_return(json_file)

      expect(login_image_streamer).to eq auth_settings
    end

    it 'should load settings from environment variables' do
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_AUTH_FILE').and_return(nil)
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_URL').and_return('https://172.16.100.182')
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_SSL_ENABLED').and_return('true')
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_LOG_LEVEL').and_return('debug')
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_API_VERSION').and_return(300)
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_TOKEN').and_return('NzA3OTg2NjM2NTk21xd-TkijbSwOjm2AvXDAL4LPG49D9K8u')

      expect(login_image_streamer).to eq auth_settings
    end

    it 'should load settings from environment variables with default values' do
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_AUTH_FILE').and_return(nil)
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_URL').and_return('https://172.16.100.182')
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_SSL_ENABLED').and_return('false')
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_LOG_LEVEL').and_return(nil)
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_API_VERSION').and_return(nil)
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_TOKEN').and_return(nil)

      auth_settings = {
        url:               'https://172.16.100.182',
        ssl_enabled:       false,
        log_level:         'info',
        api_version:       300,
        token:             nil,
        hardware_variant:  'Synergy'
      }
      expect(login_image_streamer).to eq auth_settings
    end

    it 'should raise error when authentication settings undefined' do
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_AUTH_FILE').and_return(nil)
      allow(ENV).to receive(:[]).with('IMAGE_STREAMER_URL').and_return(nil)

      error_message = /The Image Streamer credentials could not be set. Please check the documentation for more information./
      expect { login_image_streamer }.to raise_error(error_message)
    end
  end
end
