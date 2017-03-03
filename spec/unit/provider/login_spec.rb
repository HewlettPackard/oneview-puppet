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
  let(:fixtures_path) do
    File.absolute_path('spec/support/fixtures/unit/provider')
  end

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

    let(:auth_settings_default_provider) do
      {
        url:              'https://172.16.100.185',
        token:            'NzA3OTg2NjM2NTk21xd-TkijbSwOjm2AvXDAL4LPG49D9K8u',
        user:             'administrator',
        password:         'secret123',
        ssl_enabled:      true,
        api_version:      300,
        log_level:        'debug',
        hardware_variant: 'C7000'
      }
    end

    let(:config_filename) do
      'spec/support/fixtures/unit/provider/login.json'
    end

    let(:config_filename_no_provider) do
      'spec/support/fixtures/unit/provider/login_no_provider.json'
    end

    before(:each) do
      ENV['ONEVIEW_AUTH_FILE'] = nil
      ENV['ONEVIEW_URL'] = nil
      allow(Dir).to receive(:pwd).and_return('/an/unavailable/path')
    end

    describe '#oneview_credentials_set?' do
      it 'should be true when credentials are set in an existing file' do
        allow(Dir).to receive(:pwd).and_return(fixtures_path)
        expect(oneview_credentials_set?).to be
      end

      it 'should be true when credentials are set through a file defined in an env var' do
        ENV['ONEVIEW_AUTH_FILE'] = config_filename_no_provider
        expect(oneview_credentials_set?).to be
      end

      it 'should be true when credentials are set through env vars' do
        ENV['ONEVIEW_URL'] = 'https://172.16.100.185'
        expect(oneview_credentials_set?).to be
      end

      it 'should be false when no credentials set' do
        expect(oneview_credentials_set?).not_to be
      end
    end

    describe '#login' do
      it 'should load configuration from file' do
        allow(Dir).to receive(:pwd).and_return(fixtures_path)
        expect(login).to eq auth_settings
      end

      it 'should load file set in environment variable' do
        ENV['ONEVIEW_AUTH_FILE'] = config_filename
        expect(login).to eq auth_settings
      end

      it 'should load file set in environment variable with no provider' do
        ENV['ONEVIEW_AUTH_FILE'] = config_filename_no_provider
        expect(login).to eq auth_settings_default_provider
      end

      it 'should load settings from environment variables' do
        ENV['ONEVIEW_URL'] = 'https://172.16.100.185'
        ENV['ONEVIEW_SSL_ENABLED'] = 'true'
        ENV['ONEVIEW_LOG_LEVEL'] = 'debug'
        ENV['ONEVIEW_API_VERSION'] = '300'
        ENV['ONEVIEW_TOKEN'] = 'NzA3OTg2NjM2NTk21xd-TkijbSwOjm2AvXDAL4LPG49D9K8u'
        ENV['ONEVIEW_USER'] = 'administrator'
        ENV['ONEVIEW_PASSWORD'] = 'secret123'
        ENV['ONEVIEW_HARDWARE_VARIANT'] = 'Synergy'

        expect(login).to eq auth_settings
      end

      it 'should load settings from environment variables with default values' do
        ENV['ONEVIEW_URL'] = 'https://172.16.100.185'
        ENV['ONEVIEW_SSL_ENABLED'] = 'false'

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
        expect { login }.to raise_error(/The OneView credentials could not be set. Please check the documentation for more information./)
      end
    end
  end

  context 'given the Image Streamer authentication' do
    let(:auth_settings) do
      {
        url:              'https://172.16.100.182',
        token:            'NzA3OTg2NjM2NTk21xd-TkijbSwOjm2AvXDAL4LPG49D9K8u',
        ssl_enabled:      true,
        api_version:      300,
        log_level:        'debug'
      }
    end

    before(:each) do
      ENV['IMAGE_STREAMER_AUTH_FILE'] = nil
      ENV['IMAGE_STREAMER_URL'] = nil
      allow(Dir).to receive(:pwd).and_return('/an/unavailable/path')
    end

    let(:config_filename) do
      'spec/support/fixtures/unit/provider/login_image_streamer.json'
    end

    describe '#login_image_streamer' do
      it 'should load configuration from file' do
        allow(Dir).to receive(:pwd).and_return(fixtures_path)

        expect(login_image_streamer).to eq auth_settings
      end

      it 'should load file set in environment variable' do
        ENV['IMAGE_STREAMER_AUTH_FILE'] = config_filename
        expect(login_image_streamer).to eq auth_settings
      end

      it 'should load settings from environment variables' do
        ENV['IMAGE_STREAMER_URL'] = 'https://172.16.100.182'
        ENV['IMAGE_STREAMER_SSL_ENABLED'] = 'true'
        ENV['IMAGE_STREAMER_LOG_LEVEL'] = 'debug'
        ENV['IMAGE_STREAMER_API_VERSION'] = '300'
        ENV['IMAGE_STREAMER_TOKEN'] = 'NzA3OTg2NjM2NTk21xd-TkijbSwOjm2AvXDAL4LPG49D9K8u'

        expect(login_image_streamer).to eq auth_settings
      end

      it 'should load settings from environment variables with default values' do
        ENV['IMAGE_STREAMER_URL'] = 'https://172.16.100.182'
        ENV['IMAGE_STREAMER_SSL_ENABLED'] = 'false'

        auth_settings = {
          url:               'https://172.16.100.182',
          ssl_enabled:       false,
          log_level:         'info',
          api_version:       300,
          token:             nil
        }
        expect(login_image_streamer).to eq auth_settings
      end

      it 'should raise error when authentication settings undefined' do
        error_message = /The Image Streamer credentials could not be set. Please check the documentation for more information./
        expect { login_image_streamer }.to raise_error(error_message)
      end
    end
  end
end
