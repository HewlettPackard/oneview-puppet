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
require_relative '../../../lib/puppet/provider/image_streamer_resource.rb'

describe 'image_streamer_resource', unit: true do
  before(:each) do
    allow(Puppet::ImageStreamerResource).to receive(:resource_name).and_return('PlanScript')
  end

  context '#client when OneView credentials set' do
    it 'should be created through OneviewSDK::Client when set via file' do
      allow(Dir).to receive(:pwd).and_return('spec/support/fixtures/unit/provider/login.json')
      expect_any_instance_of(OneviewSDK::Client).to receive(:new_i3s_client)
      Puppet::ImageStreamerResource.new
    end

    it 'should be created through OneviewSDK::Client when set via filepath stored in env var' do
      ENV['ONEVIEW_AUTH_FILE'] = 'spec/support/fixtures/unit/provider/login.json'
      expect_any_instance_of(OneviewSDK::Client).to receive(:new_i3s_client)
      Puppet::ImageStreamerResource.new
    end

    it 'should be created through OneviewSDK::Client when set via env vars' do
      ENV['ONEVIEW_URL'] = 'https://172.16.100.185'
      expect_any_instance_of(OneviewSDK::Client).to receive(:new_i3s_client)
      Puppet::ImageStreamerResource.new
    end

    it 'should be an instance of OneviewSDK::ImageStreamer::Client' do
      resource = Puppet::ImageStreamerResource.new
      allow_any_instance_of(Puppet::ImageStreamerResource).to receive(:oneview_credentials_set?).and_return(true)
      expect(resource.client).to be_an_instance_of OneviewSDK::ImageStreamer::Client
    end
  end

  context '#client when OneView credentials unset' do
    before(:each) do
      ENV['ONEVIEW_AUTH_FILE'] = nil
      ENV['ONEVIEW_URL'] = nil
      allow(Dir).to receive(:pwd).and_return('/an/unavailable/path')
    end

    it 'should not be created through OneviewSDK::Client' do
      allow_any_instance_of(Puppet::ImageStreamerResource).to receive(:oneview_credentials_set?).and_return(false)
      expect_any_instance_of(OneviewSDK::Client).not_to receive(:new_i3s_client)
      Puppet::ImageStreamerResource.new
    end

    it 'should be an instance of OneviewSDK::ImageStreamer::Client' do
      resource = Puppet::ImageStreamerResource.new
      allow_any_instance_of(Puppet::ImageStreamerResource).to receive(:oneview_credentials_set?).and_return(false)
      expect(resource.client).to be_an_instance_of OneviewSDK::ImageStreamer::Client
    end
  end

  context '#ov_resource_type' do
    it 'should return the right resource type' do
      resource = Puppet::ImageStreamerResource.new
      expect(resource.ov_resource_type).to eq(OneviewSDK::ImageStreamer::API300::PlanScript)
    end
  end
end
