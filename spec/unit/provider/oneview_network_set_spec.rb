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

provider_class = Puppet::Type.type(:oneview_network_set).provider(:oneview_network_set)
resourcetype = OneviewSDK::NetworkSet

describe provider_class, unit: true do
  include_context 'shared context'

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_network_set).new(
        name: 'Network Set',
        ensure: 'present',
        data:
            {
              'name' => 'Network Set'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_network_set).provider(:oneview_network_set)
    end

    it 'should return that the resource does not exists' do
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should return that the resource exists' do
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.found).to be
    end

    it 'should be able to create the resource' do
      data = { 'name' => 'Network Set', 'connectionTemplateUri' => nil, 'nativeNetworkUri' => nil, 'networkUris' => [],
               'type' => 'network-set' }
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with('/rest/network-sets', { 'body' => data }, test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/network-sets/fake')
      expect(provider.create).to be
    end

    it 'should be able to delete the resource' do
      resource['data']['uri'] = '/rest/fake'
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      allow(resourcetype).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      provider.exists?
      expect(provider.destroy).to be
    end

    it 'should be able to get all the network sets without ethernet' do
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
      allow_any_instance_of(resourcetype).to receive(:get_without_ethernet).and_return([test])
      expect(provider.get_without_ethernet).to be
    end

    it 'should be able to set the native network' do
      resource['data']['nativeNetwork'] = 'Ethernet'
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
      ethernet = OneviewSDK::EthernetNetwork.new(@client, name: 'Ethernet')
      allow(OneviewSDK::EthernetNetwork).to receive(:find_by).with(anything, name: 'Ethernet').and_return([ethernet])
      allow_any_instance_of(resourcetype).to receive(:set_native_network).with(ethernet).and_return('Test')
      allow_any_instance_of(resourcetype).to receive(:update).and_return('Test')
      expect(provider.set_native_network).to be
    end

    it 'should be able to add an ethernet network' do
      resource['data']['ethernetNetworks'] = ['Ethernet 1']
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
      ethernet = OneviewSDK::EthernetNetwork.new(@client, name: 'Ethernet 1')
      allow(OneviewSDK::EthernetNetwork).to receive(:find_by).with(anything, name: 'Ethernet 1').and_return([ethernet])
      allow_any_instance_of(resourcetype).to receive(:add_ethernet_network).with(ethernet).and_return('Test')
      allow_any_instance_of(resourcetype).to receive(:update).and_return('Test')
      expect(provider.add_ethernet_network).to be
    end

    it 'should be able to remove an ethernet network' do
      resource['data']['ethernetNetworks'] = ['Ethernet 1']
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
      ethernet = OneviewSDK::EthernetNetwork.new(@client, name: 'Ethernet 1')
      allow(OneviewSDK::EthernetNetwork).to receive(:find_by).with(anything, name: 'Ethernet 1').and_return([ethernet])
      allow_any_instance_of(resourcetype).to receive(:remove_ethernet_network).with(ethernet).and_return('Test')
      allow_any_instance_of(resourcetype).to receive(:update).and_return('Test')
      expect(provider.remove_ethernet_network).to be
    end
  end
end
