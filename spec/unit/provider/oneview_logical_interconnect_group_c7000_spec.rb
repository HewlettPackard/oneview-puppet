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

provider_class = Puppet::Type.type(:oneview_logical_interconnect_group).provider(:c7000)
api_version = login[:api_version] || 200
resource_name = 'LogicalInterconnectGroup'
resourcetype ||= if api_version == 200
                   Object.const_get("OneviewSDK::API#{api_version}::#{resource_name}")
                 else
                   Object.const_get("OneviewSDK::API#{api_version}::C7000::#{resource_name}")
                 end

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_logical_interconnect_group).new(
      name: 'LIG',
      ensure: 'present',
      data:
          {
            'name' => 'OneViewSDK Test Logical Switch Group',
            'enclosureType' => 'C7000',
            'type' => 'logical-interconnect-groupV3'
          },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resourcetype.new(@client, resource['data']) }

  context 'given the min parameters' do
    before(:each) do
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_interconnect_group).provider(:c7000)
    end

    it 'return false when the resource does not exists' do
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'runs through the create method' do
      allow(resourcetype).to receive(:find_by).and_return([])
      allow(OneviewSDK::UplinkSet).to receive(:find_by)
        .and_return([OneviewSDK::UplinkSet.new(@client, name: 'testup', uri: '/rest/fakeup')])
      allow(OneviewSDK::EthernetNetwork).to receive(:find_by)
        .and_return([OneviewSDK::EthernetNetwork.new(@client, name: 'testnet', uri: '/rest/fakenet')])
      allow_any_instance_of(resourcetype).to receive(:add_interconnect).with(1, 'HP VC FlexFabric 10Gb/24-Port Module').and_return('')
      allow_any_instance_of(resourcetype).to receive(:create).and_return(test)
      resource['data']['interconnects'] = [{ 'bay' => 1, 'type' => 'HP VC FlexFabric 10Gb/24-Port Module' }]
      resource['data']['uplinkSets'] = ['test']
      resource['data']['internalNetworkUris'] = [%w(testnet1 testnet2)]
      provider.exists?
      expect(provider.create).to be
    end

    it 'should be able to get the default settings' do
      provider.exists?
      allow_any_instance_of(resourcetype).to receive(:get_default_settings).and_return('Test')
      expect(provider.get_default_settings).to be
    end

    it 'should be able to get the settings' do
      allow_any_instance_of(resourcetype).to receive(:get_settings).and_return('Test')
      expect(provider.get_settings).to be
    end

    it 'should be able to find the resource' do
      expect(provider.found).to be
    end

    it 'deletes the resource' do
      expect_any_instance_of(resourcetype).to receive(:delete).and_return([])
      expect(provider.destroy).to be
    end
  end
end
