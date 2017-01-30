################################################################################
# (C) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
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
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_server_profile_template).provider(:c7000)
api_version = login[:api_version] || 200
resource_name = 'ServerProfileTemplate'
resourcetype = if api_version == 200
                 Object.const_get("OneviewSDK::API#{api_version}::#{resource_name}")
               else
                 Object.const_get("OneviewSDK::API#{api_version}::C7000::#{resource_name}")
               end

describe provider_class, unit: true do
  include_context 'shared context'

  context 'given the creation parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_server_profile_template).new(
        name: 'spt',
        ensure: 'present',
        data:
            {
              'name'                  => 'SPT',
              'enclosureGroupUri'     => '/rest/',
              'serverHardwareTypeUri' => '/rest/'
            },
        provider: 'c7000'
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    let(:test) { resourcetype.new(@client, resource['data']) }

    before(:each) do
      allow(resourcetype).to receive(:find_by).and_return([test])
    end

    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_server_profile_template).provider(:c7000)
    end

    it 'should run exists? and return the resource does not exist' do
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should return the resource has been found' do
      provider.exists?
      expect(provider.found).to be
    end

    it 'should return that the resource exists' do
      expect(provider.exists?).to eq(true)
    end

    it 'should be able to create the resource' do
      allow(resourcetype).to receive(:find_by).and_return([])
      allow_any_instance_of(resourcetype).to receive(:create).and_return(resourcetype.new(@client, resource['data']))
      expect(provider.exists?).to eq(false)
      expect(provider.create).to be
    end

    it 'should be able to create a server profile with default name using the template' do
      server_profile = OneviewSDK::ServerProfile.new(@client, name: 'Server_Profile_created_from_SPT')
      allow(OneviewSDK::ServerProfile).to receive(:find_by).and_return([])
      allow_any_instance_of(resourcetype).to receive(:new_profile).and_return(server_profile)
      allow(server_profile).to receive(:create).and_return(server_profile)
      provider.exists?
      expect(provider.set_new_profile).to be
    end

    it 'should not create a server profile with default name when already exists' do
      server_profile = OneviewSDK::ServerProfile.new(@client, name: 'Server_Profile_created_from_SPT')
      allow(OneviewSDK::ServerProfile).to receive(:find_by).and_return([server_profile])
      provider.exists?
      expect(provider.set_new_profile).to be_nil
    end

    it 'should be able to create a server profile with given name using the template' do
      resource['data']['serverProfileName'] = 'New Server Profile'
      server_profile = OneviewSDK::ServerProfile.new(@client, name: 'New Server Profile')
      allow(OneviewSDK::ServerProfile).to receive(:find_by).and_return([])
      allow_any_instance_of(resourcetype).to receive(:new_profile).and_return(server_profile)
      allow(server_profile).to receive(:create).and_return(server_profile)
      provider.exists?
      expect(provider.set_new_profile).to be
    end

    it 'should not create a server profile with given name using the template when already exists' do
      resource['data']['serverProfileName'] = 'New Server Profile'
      server_profile = OneviewSDK::ServerProfile.new(@client, name: 'New Server Profile')
      allow(OneviewSDK::ServerProfile).to receive(:find_by).and_return([server_profile])
      provider.exists?
      expect(provider.set_new_profile).to be_nil
    end

    it 'should be able to get a server profile template with a new configuration', if: api_version >= 300 do
      resource['data']['queryParameters'] = {
        'enclosureGroupUri'     => 'NameInterconn40GB',
        'serverHardwareTypeUri' => 'SY 480 Gen9 1'
      }
      fake_server_profile = { 'name' => 'Fake profile template with a new configuration' }
      allow_any_instance_of(resourcetype).to receive(:get_transformation).and_return(fake_server_profile)
      expect(provider.get_transformation).to be
    end

    it 'should be able to delete the resource' do
      resource['data'] = { 'name' => 'SPT', 'uri' => '/rest/fake' }
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      expect_any_instance_of(resourcetype).to receive(:delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      provider.exists?
      expect(provider.destroy).to be
    end
  end
end
