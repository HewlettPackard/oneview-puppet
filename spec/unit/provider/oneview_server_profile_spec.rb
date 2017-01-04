################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
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

provider_class = Puppet::Type.type(:oneview_server_profile).provider(:oneview_server_profile)
resourcetype = OneviewSDK::ServerProfile
fake_json_response = File.read('spec/support/fixtures/unit/provider/server_profile.json')

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_server_profile).new(
      name: 'Server Profile',
      ensure: 'present',
      data:
          {
            'name' => 'Profile',
            'serverHardwareUri' => '/rest/server-hardware/37333036-3831-584D-5131-303030323037',
            'type' => 'ServerProfileV5'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters before server creation' do
    before(:each) do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_server_profile).provider(:oneview_server_profile)
    end

    it 'should raise error when server is not found' do
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([])
      expect { provider.found }.to raise_error(/No ServerProfile with the specified data were found on the Oneview Appliance/)
    end

    it 'should be able to find the server profile' do
      expect(provider.exists?).to eq(true)
      expect(provider.found).to be
    end

    it 'should be able to create the resource' do
      allow(resourcetype).to receive(:find_by).and_return([])
      allow_any_instance_of(resourcetype).to receive(:create).and_return(resourcetype.new(@client, resource['data']))
      expect(provider.exists?).to eq(false)
      expect(provider.create).to be
    end

    it 'should be able to perform the patch update' do
      allow_any_instance_of(resourcetype).to receive(:update_from_template).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.update_from_template).to be
    end

    it 'should be able to get available targets' do
      allow(resourcetype).to receive(:get_available_targets).with(anything, nil).and_return(fake_json_response)
      expect(provider.get_available_targets).to be
    end

    it 'should be able to get the compliance preview' do
      allow_any_instance_of(resourcetype).to receive(:get_compliance_preview).and_return(fake_json_response)
      expect(provider.get_compliance_preview).to be
    end

    it 'should be able to get available networks' do
      allow_any_instance_of(resourcetype).to receive(:get_available_networks).and_return(fake_json_response)
      expect(provider.get_available_networks).to be
    end

    it 'should be able to get the transformation' do
      allow_any_instance_of(resourcetype).to receive(:get_transformation).and_return(fake_json_response)
      expect(provider.get_transformation).to be
    end

    it 'should be able to get messages' do
      allow_any_instance_of(resourcetype).to receive(:get_messages).and_return(fake_json_response)
      expect(provider.get_messages).to be
    end

    it 'should be able to get available servers' do
      allow(resourcetype).to receive(:get_available_servers).and_return(fake_json_response)
      expect(provider.get_available_servers).to be
    end

    it 'should be able to get profile ports' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
      allow(resourcetype).to receive(:get_profile_ports).and_return(fake_json_response)
      expect(provider.get_profile_ports).to be
    end

    it 'should delete the server profile' do
      resource['data']['uri'] = '/rest/server-profiles/fake'
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.destroy).to be
    end
  end
end
