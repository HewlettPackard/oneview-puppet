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
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_uplink_set).provider(:oneview_uplink_set)

describe provider_class, unit: true do
  include_context 'shared context'

  @resourcetype = OneviewSDK::UplinkSet

  let(:resource) do
    Puppet::Type.type(:oneview_uplink_set).new(
      name: 'uplink_set_1',
      ensure: 'found'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the Creation parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_uplink_set).new(
        name: 'uplink_set_1',
        ensure: 'present',
        data:
            {
              'nativeNetworkUri'               => 'nil',
              'reachability'                   => 'Reachable',
              'manualLoginRedistributionState' => 'NotSupported',
              'connectionMode'                 => 'Auto',
              'lacpTimer'                      => 'Short',
              'networkType'                    => 'Ethernet',
              'ethernetNetworkType'            => 'Tagged',
              'description'                    => 'nil',
              'name'                           => 'Puppet Uplink Set',
              'portConfigInfos' =>
              [
                '/rest/interconnects/8e48bbd0-b651-46e1-afdf-334332a3a233',
                'Auto',
                [{ value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH100X6J1', type: 'Enclosure' }, { value: 'X1', type: 'Port' }]
              ],
              'networkUris' => [
                '/rest/fake/1', '/rest/fake/2'
              ],
              'logicalInterconnectUri' => '/rest/fake/3'
            }
      )
    end

    it 'should be an instance of the provider oneview_uplink_set' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_uplink_set).provider(:oneview_uplink_set)
    end

    it 'should return false if resource does not exist' do
      allow(OneviewSDK::UplinkSet).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should return false if resource is not found' do
      allow(OneviewSDK::UplinkSet).to receive(:find_by).and_return([])
      provider.exists?
      expect { provider.found }.to raise_error(/No UplinkSet with the specified data were found on the Oneview Appliance/)
    end

    it 'should return true if resource is found' do
      unique_id = { 'uri' => '/rest/uplink-sets/fake', 'name' => 'Puppet Uplink Set' }
      resource['data']['uri'] = '/rest/uplink-sets/fake'
      test = OneviewSDK::UplinkSet.new(@client, resource['data'])
      allow(OneviewSDK::UplinkSet).to receive(:find_by).with(anything, unique_id).and_return([test])
      allow(OneviewSDK::UplinkSet).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      allow(OneviewSDK::UplinkSet).to receive(:find_by).with(anything, resource['data']).and_return([test])
      # expect_any_instance_of(OneviewSDK::UplinkSet).to receive(:update).and_return(FakeResponse.new('uri' => '/rest/fake'))
      provider.exists?
      expect(provider.found).to eq(true)
    end

    it 'runs through the create method' do
      data = { 'nativeNetworkUri' => nil, 'reachability' => 'Reachable', 'manualLoginRedistributionState' => 'NotSupported',
               'connectionMode' => 'Auto', 'lacpTimer' => 'Short', 'networkType' => 'Ethernet', 'ethernetNetworkType' => 'Tagged',
               'description' => nil, 'name' => 'Puppet Uplink Set', 'logicalInterconnectUri' => '/rest/fake/3',
               'fcoeNetworkUris' => [], 'fcNetworkUris' => [], 'networkUris' => ['/rest/fake/1', '/rest/fake/2'],
               'portConfigInfos' => [
                 { 'portUri' => '/rest/interconnects/8e48bbd0-b651-46e1-afdf-334332a3a233',
                   'desiredSpeed' => 'Auto', 'location' => {
                     'locationEntries' => [
                       { value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH100X6J1',
                                                    type: 'Enclosure' }, { value: 'X1', type: 'Port' }
                     ]
                   } }
               ], 'primaryPortLocation' => nil, 'type' => 'uplink-setV3' }
      test = OneviewSDK::UplinkSet.new(@client, resource['data'])
      network = OneviewSDK::EthernetNetwork.new(@client, name: 'Puppet Test EthNetwork', uri: '/rest/ethernet-networks/fake')
      logint = OneviewSDK::LogicalInterconnect.new(@client, name: 'Encl1-Test Oneview', uri: '/rest/logical-interconnects/fake')
      allow(OneviewSDK::UplinkSet).to receive(:find_by).with(anything, resource['data']).and_return([test])
      allow(OneviewSDK::EthernetNetwork).to receive(:find_by).and_return([network])
      allow(OneviewSDK::LogicalInterconnect).to receive(:find_by).and_return([logint])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with('/rest/uplink-sets', { 'body' => data }, test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/uplink-sets/fake')
      provider.exists?
      expect(provider.create).to eq(true)
    end
  end

  # TODO: Fix type test eventually
  # context 'given the minimum parameters' do
  #   let(:resource) do
  #     Puppet::Type.type(:oneview_uplink_set).new(
  #       name: 'uplink_set_1',
  #     ensure: 'found',
  #       data: 'Wrong Kind of Data ',
  #       network: 'Puppet Test EthNetwork',
  #       logical_interconnect: 'Encl1-Test Oneview'
  #     )
  #   end
  #
  #   it 'should fail if data is not a hash' do
  #     expect(Puppet::Type::Oneview_uplink_set::Provideroneview_uplink_set).to raise_error
  #   end
  #
  # end
  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_uplink_set).new(
        name: 'uplink_set_1',
        ensure: 'absent',
        data:
            {
              'nativeNetworkUri'               => 'nil',
              'reachability'                   => 'Reachable',
              'manualLoginRedistributionState' => 'NotSupported',
              'connectionMode'                 => 'Auto',
              'lacpTimer'                      => 'Short',
              'networkType'                    => 'Ethernet',
              'ethernetNetworkType'            => 'Tagged',
              'description'                    => 'nil',
              'name'                           => 'Puppet Uplink Set',
              'portConfigInfos' =>
              [
                '/rest/interconnects/8e48bbd0-b651-46e1-afdf-334332a3a233',
                'Auto',
                [{ value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH100X6J1', type: 'Enclosure' }, { value: 'X1', type: 'Port' }]
              ],
              'networkUris' => [
                '/rest/fake/1', '/rest/fake/2'
              ],
              'logicalInterconnectUri'         => '/rest/fake/3'
            }
      )
    end
    it 'deletes the resource' do
      resource['data']['uri'] = '/rest/fake'
      test = OneviewSDK::UplinkSet.new(@client, resource['data'])
      allow(OneviewSDK::UplinkSet).to receive(:find_by).with(anything, resource['data']).and_return([test])
      allow(OneviewSDK::UplinkSet).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      provider.exists?
      expect(provider.destroy).to be
    end
  end

  context 'Run ensure with a different option than present' do
    let(:resource) do
      Puppet::Type.type(:oneview_uplink_set).new(
        name: 'uplink_set_1',
        ensure: 'found',
        data: {
          'networkUris' => [
            '/rest/fake/1', '/rest/fake/2'
          ],
          'logicalInterconnectUri' => '/rest/fake/3'
        }
      )
    end

    it 'Should return false when nothing exists' do
      allow(OneviewSDK::UplinkSet).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end
  end

  context 'When using FC Network ' do
    let(:resource) do
      Puppet::Type.type(:oneview_uplink_set).new(
        name: 'uplink_set_1',
        ensure: 'present',
        data:
            {
              'nativeNetworkUri'               => 'nil',
              'reachability'                   => 'Reachable',
              'manualLoginRedistributionState' => 'NotSupported',
              'connectionMode'                 => 'Auto',
              'lacpTimer'                      => 'Short',
              'networkType'                    => 'Ethernet',
              'ethernetNetworkType'            => 'Tagged',
              'description'                    => 'nil',
              'name'                           => 'Puppet Uplink Set',
              'portConfigInfos' =>
              [
                '/rest/interconnects/8e48bbd0-b651-46e1-afdf-334332a3a233',
                'Auto',
                [{ value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH100X6J1', type: 'Enclosure' }, { value: 'X1', type: 'Port' }]
              ],
              'fcNetworkUris' => [
                '/rest/fake/1', '/rest/fake/2'
              ],
              'logicalInterconnectUri' => '/rest/fake/3'
            }
      )
    end

    it 'runs through the create method' do
      allow(OneviewSDK::UplinkSet).to receive(:find_by).with(anything, resource['data']).and_return([])
      data = { 'nativeNetworkUri' => nil, 'reachability' => 'Reachable', 'manualLoginRedistributionState' => 'NotSupported',
               'connectionMode' => 'Auto', 'lacpTimer' => 'Short', 'networkType' => 'Ethernet', 'ethernetNetworkType' => 'Tagged',
               'description' => nil, 'name' => 'Puppet Uplink Set', 'logicalInterconnectUri' => '/rest/fake/3',
               'fcoeNetworkUris' => [], 'fcNetworkUris' => ['/rest/fake/1', '/rest/fake/2'], 'networkUris' => [],
               'portConfigInfos' => [
                 { 'portUri' => '/rest/interconnects/8e48bbd0-b651-46e1-afdf-334332a3a233',
                   'desiredSpeed' => 'Auto', 'location' => {
                     'locationEntries' => [
                       { value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH100X6J1',
                                                    type: 'Enclosure' }, { value: 'X1', type: 'Port' }
                     ]
                   } }
               ], 'primaryPortLocation' => nil, 'type' => 'uplink-setV3' }
      test = OneviewSDK::UplinkSet.new(@client, resource['data'])
      fc_network = OneviewSDK::FCNetwork.new(@client, name: 'Puppet Test FCNetwork', uri: '/rest/fc-networks/fake')
      logint = OneviewSDK::LogicalInterconnect.new(@client, name: 'Encl1-Test Oneview', uri: '/rest/logical-interconnects/fake')
      allow(OneviewSDK::FCNetwork).to receive(:find_by).and_return([fc_network])
      allow(OneviewSDK::LogicalInterconnect).to receive(:find_by).and_return([logint])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with('/rest/uplink-sets', { 'body' => data }, test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/uplink-sets/fake')
      provider.exists?
      expect(provider.create).to eq(true)
    end
  end

  context 'When using FCoE Network ' do
    let(:resource) do
      Puppet::Type.type(:oneview_uplink_set).new(
        name: 'uplink_set_1',
        ensure: 'present',
        data:
            {
              'nativeNetworkUri'               => 'nil',
              'reachability'                   => 'Reachable',
              'manualLoginRedistributionState' => 'NotSupported',
              'connectionMode'                 => 'Auto',
              'lacpTimer'                      => 'Short',
              'networkType'                    => 'Ethernet',
              'ethernetNetworkType'            => 'Tagged',
              'description'                    => 'nil',
              'name'                           => 'Puppet Uplink Set',
              'portConfigInfos' =>
              [
                '/rest/interconnects/8e48bbd0-b651-46e1-afdf-334332a3a233',
                'Auto',
                [{ value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH100X6J1', type: 'Enclosure' }, { value: 'X1', type: 'Port' }]
              ],
              'fcoeNetworkUris' => [
                '/rest/fake/1', '/rest/fake/2'
              ],
              'logicalInterconnectUri' => '/rest/fake/3'
            }
      )
    end

    it 'runs through the create method' do
      allow(OneviewSDK::UplinkSet).to receive(:find_by).with(anything, resource['data']).and_return([])
      data = { 'nativeNetworkUri' => nil, 'reachability' => 'Reachable', 'manualLoginRedistributionState' => 'NotSupported',
               'connectionMode' => 'Auto', 'lacpTimer' => 'Short', 'networkType' => 'Ethernet', 'ethernetNetworkType' => 'Tagged',
               'description' => nil, 'name' => 'Puppet Uplink Set', 'logicalInterconnectUri' => '/rest/fake/3',
               'fcoeNetworkUris' => ['/rest/fake/1', '/rest/fake/2'], 'fcNetworkUris' => [], 'networkUris' => [],
               'portConfigInfos' => [
                 { 'portUri' => '/rest/interconnects/8e48bbd0-b651-46e1-afdf-334332a3a233',
                   'desiredSpeed' => 'Auto', 'location' => {
                     'locationEntries' => [
                       { value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH100X6J1',
                                                    type: 'Enclosure' }, { value: 'X1', type: 'Port' }
                     ]
                   } }
               ], 'primaryPortLocation' => nil, 'type' => 'uplink-setV3' }
      test = OneviewSDK::UplinkSet.new(@client, resource['data'])
      fcoe_network = OneviewSDK::FCoENetwork.new(@client, name: 'Puppet Test FCoENetwork', uri: '/rest/fcoe-networks/fake')
      logint = OneviewSDK::LogicalInterconnect.new(@client, name: 'Encl1-Test Oneview', uri: '/rest/logical-interconnects/fake')
      allow(OneviewSDK::FCoENetwork).to receive(:find_by).and_return([fcoe_network])
      allow(OneviewSDK::LogicalInterconnect).to receive(:find_by).and_return([logint])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with('/rest/uplink-sets', { 'body' => data }, test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/uplink-sets/fake')
      provider.exists?
      expect(provider.create).to eq(true)
    end
  end
end
