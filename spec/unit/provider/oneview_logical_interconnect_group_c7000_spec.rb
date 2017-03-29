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
resource_type ||= OneviewSDK.resource_named(:LogicalInterconnectGroup, api_version, :C7000)
ethtype ||= OneviewSDK.resource_named(:EthernetNetwork, api_version, :C7000)
interconnect_type ||= OneviewSDK.resource_named(:Interconnect, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_logical_interconnect_group).new(
      name: 'LIG',
      ensure: 'present',
      data:
      {
        'name'          => 'PUPPET_TEST_LIG',
        'type'          => 'logical-interconnect-groupV300',
        'enclosureType' => 'C7000',
        'state'         => 'Active'
      },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  context 'given the min parameters' do
    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_interconnect_group).provider(:c7000)
    end

    it 'return false when the resource does not exists' do
      allow(resource_type).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should be able to get the default settings' do
      provider.exists?
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

  context 'given the #uplink sets and interconnects parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_interconnect_group).new(
        name: 'LIG',
        ensure: 'present',
        data:
        {
          'name'          => 'PUPPET_TEST_LIG',
          'type'          => 'logical-interconnect-groupV300',
          'enclosureType' => 'C7000',
          'state'         => 'Active',
          'uplinkSets'    => [
            {
              'name'                => 'TUNNEL_ETH_UP_01',
              'ethernetNetworkType' => 'Tunnel',
              'networkType'         => 'Ethernet',
              'lacpTimer'           => 'Short',
              'mode'                => 'Auto',
              'uplink_ports'        => [{ 'bay'  => 1,
                                          'port' => 'X5' },
                                        { 'bay'  => 1,
                                          'port' => 'X6' },
                                        { 'bay'  => 2,
                                          'port' => 'X7' },
                                        { 'bay'  => 2,
                                          'port' => 'X8' }],
              'networkUris'         => [
                { name: 'test_network' }
              ]
            }
          ],
          'interconnects' => [
            { 'bay'  => 1,
              'type' => 'HP VC FlexFabric 10Gb/24-Port Module' },
            { 'bay'  => 2,
              'type' => 'HP VC FlexFabric 10Gb/24-Port Module' }
          ],
          'internalNetworkUris' => ['test']
        },
        provider: 'c7000'
      )
    end

    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      allow(ethtype).to receive(:find_by).and_return([ethtype.new(@client, name: 'fake_eth', uri: '/rest/fake_uri')])
      allow(interconnect_type).to receive(:get_type).and_return('uri' => '/fake/interconnect_type_uri')
      provider.exists?
    end

    it 'runs through the create method' do
      allow(resource_type).to receive(:find_by).and_return([])
      allow_any_instance_of(resource_type).to receive(:create).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end
  end
end
