################################################################################
# (C) Copyright 2016-2020 Hewlett Packard Enterprise Development LP
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

provider_class = Puppet::Type.type(:oneview_logical_interconnect_group).provider(:synergy)
api_version = login[:api_version] || 200
resource_type ||= OneviewSDK.resource_named(:LogicalInterconnectGroup, api_version, :Synergy)
interconnect_type ||= OneviewSDK.resource_named(:Interconnect, api_version, :Synergy)

describe provider_class, unit: true, if: api_version >= 300 do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_logical_interconnect_group).new(
      name: 'LIG',
      ensure: 'present',
      data:
      {
        'name'               => 'Puppet LIG Synergy',
        'redundancyType'     => 'Redundant',
        'interconnectBaySet' => 3,
        'interconnects'      =>
        [
          {
            'bay'  => 3,
            'type' => 'Virtual Connect SE 40Gb F8 Module for Synergy'
          },
          {
            'bay'  => 6,
            'type' => 'Virtual Connect SE 40Gb F8 Module for Synergy'
          }
        ]
      },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  context 'given the min parameters' do
    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      allow(interconnect_type).to receive(:get_type).and_return('uri' => '/fake/interconnect_type_uri')
      provider.exists?
    end

    it 'should be an instance of the provider synergy' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_interconnect_group).provider(:synergy)
    end

    it 'return false when the resource does not exists' do
      allow(resource_type).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'runs through the create method' do
      allow(resource_type).to receive(:find_by).and_return([])
      allow(OneviewSDK::EthernetNetwork).to receive(:find_by)
        .and_return([OneviewSDK::EthernetNetwork.new(@client, name: 'testnet', uri: '/rest/fakenet')])
      allow_any_instance_of(resource_type).to receive(:add_interconnect).and_return('')
      allow_any_instance_of(resource_type).to receive(:create).and_return(test)
      resource['data']['interconnects'] = [{ 'bay' => 1, 'type' => 'HP VC FlexFabric 10Gb/24-Port Module' }]
      resource['data']['internalNetworkUris'] = [%w(testnet1 testnet2)]
      provider.exists?
      expect(provider.create).to be
    end

    it 'should be able to get the default settings' do
      allow(resource_type).to receive(:get_default_settings).and_return('Test')
      expect(provider.get_default_settings).to be
    end

    it 'should be able to get the settings' do
      allow_any_instance_of(resource_type).to receive(:get_settings).and_return('Test')
      expect(provider.get_settings).to be
    end

    it 'should be able to find the resource' do
      expect(provider.found).to be
    end

    it 'deletes the resource' do
      expect_any_instance_of(resource_type).to receive(:delete).and_return([])
      expect(provider.destroy).to be
    end
  end
end
