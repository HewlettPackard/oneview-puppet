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

provider_class = Puppet::Type.type(:oneview_power_device).provider(:c7000)

api_version = login[:api_version] || 200
resource_name = 'PowerDevice'
resourcetype = Object.const_get("OneviewSDK::API#{api_version}::C7000::#{resource_name}") unless api_version < 300

describe provider_class, unit: true, if: login[:api_version] >= 300 do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_power_device).new(
      name: 'Power Device',
      ensure: 'discover',
      data:
          {
            'name' => '172.18.8.11, PDU 1'
          },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resourcetype.new(@client, resource['data']) }

  before(:each) do
    allow(resourcetype).to receive(:find_by).and_return([test])
    provider.exists?
  end

  context 'given the minimum parameters before server creation' do
    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_power_device).provider(:c7000)
    end

    it 'should be able to find the resource' do
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect(provider.exists?).to be
      expect(provider.found).to be
    end

    it 'should not be able to find the resource' do
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([])
      expect(provider.exists?).not_to be
      expect { provider.found }.to raise_error(/No PowerDevice with the specified data were found on the Oneview Appliance/)
    end

    it 'should be able to discover the power device' do
      allow(resourcetype).to receive(:discover).with(anything, resource['data']).and_return('Test')
      expect(provider.discover).to be
    end

    it 'should get the UID state' do
      allow_any_instance_of(resourcetype).to receive(:get_uid_state).and_return('Test')
      expect(provider.get_uid_state).to be
    end

    it 'should get the utilization without parameters' do
      allow_any_instance_of(resourcetype).to receive(:utilization).with({}).and_return('Test')
      expect(provider.get_utilization).to be
    end
  end

  context 'given the set_refresh_state parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_power_device).new(
        name: 'Power Device',
        ensure: 'set_refresh_state',
        data:
            {
              'name' => '172.18.8.11, PDU 1',
              'refreshOptions' =>
              {
                'refreshState' => 'RefreshPending',
                'username'     => 'dcs',
                'password'     => 'dcs'
              }
            },
        provider: 'c7000'
      )
    end

    it 'should refresh the power device' do
      expect_any_instance_of(resourcetype).to receive(:set_refresh_state).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.set_refresh_state).to be
    end
  end

  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_power_device).new(
        name: 'Power Device',
        ensure: 'absent',
        data:
            {
              'name' => '172.18.8.11, PDU 1',
              'uidState' => 'On',
              'powerState' => 'On'
            },
        provider: 'c7000'
      )
    end

    it 'should delete the resource' do
      provider.exists?
      expect_any_instance_of(resourcetype).to receive(:remove).and_return(true)
      expect(provider.destroy).to be
    end

    it 'should be able to create the resource' do
      allow(resourcetype).to receive(:find_by).and_return([])
      allow_any_instance_of(resourcetype).to receive(:add).and_return(resourcetype.new(@client, name: resource['data']['name']))
      expect(provider.exists?).to eq(false)
      expect(provider.create).to be
    end

    it 'should set the uid state' do
      expect(provider.exists?).to eq(true)
      expect_any_instance_of(resourcetype).to receive(:set_uid_state).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.set_uid_state).to be
    end

    it 'should set the power state' do
      expect(provider.exists?).to eq(true)
      expect_any_instance_of(resourcetype).to receive(:set_power_state).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.set_power_state).to be
    end

    it 'should be able to retrieve the power connections by name instead of uri' do
      allow(OneviewSDK::FCNetwork).to receive(:find_by).and_return([test])
      allow_any_instance_of(resourcetype).to receive(:add).and_return(test)
      allow_any_instance_of(resourcetype).to receive(:update).and_return(test)
      resource['data']['powerConnections'] = [{ 'name' => 'test', 'type' => 'FCNetwork' }]
      provider.exists?
      expect(provider.create).to be
    end
  end
end
