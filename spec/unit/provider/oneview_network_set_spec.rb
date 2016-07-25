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

provider_class = Puppet::Type.type(:oneview_network_set).provider(:ruby)
resourcetype = OneviewSDK::NetworkSet

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_network_set).new(
      name: 'Network Set',
      ensure: 'present',
      data:
          {
            'name' => 'Network Set',
            'nativeNetwork' => 'Ethernet 1',
            'ethernetNetworks' => ['Ethernet 1', 'Ethernet 2']
          }
    )
  end

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
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_network_set).provider(:ruby)
    end

    it 'should return that the resource does not exists' do
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
      expect { provider.found }.to raise_error(Puppet::Error, 'The Network Set does not exists.')
    end

    it 'should return that the resource exists' do
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.found).to eq(true)
    end

    it 'should be able to get the schema' do
      schema = 'spec/support/fixtures/unit/provider/network_set_schema.json'
      allow_any_instance_of(resourcetype).to receive(:schema).and_return(File.read(schema))
      expect(provider.get_schema).to eq(true)
    end

    it 'should be able to create the resource' do
      data = { 'name' => 'Network Set', 'connectionTemplateUri' => nil, 'nativeNetworkUri' => nil, 'networkUris' => [],
               'type' => 'network-set' }
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow_any_instance_of(resourcetype).to receive(:retrieve!).and_return(false)
      expect(provider.exists?).to eq(false)
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with('/rest/network-sets', { 'body' => data }, test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/network-sets/fake')
      expect(provider.create).to be
    end

    it 'deletes the resource' do
      resource['data']['uri'] = '/rest/fake'
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      # expect_any_instance_of(resourcetype).to receive(:update).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.exists?).to eq(true)
      expect(provider.destroy).to eq(true)
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_network_set).new(
        name: 'Network Set',
        ensure: 'get_network_sets',
        data:
            {
              'name' => 'Network Set'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be able to get all the network sets' do
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      expect(provider.get_network_sets).to eq(true)
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_network_set).new(
        name: 'Network Set',
        ensure: 'add_ethernet_network',
        data:
            {
              'name' => 'Network Set',
              'nativeNetwork' => 'Ethernet 1',
              'ethernetNetworks' => ['Ethernet 1']
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    # TODO: something is preventing the method from passing the update
    #       finish covering network update methods
    # it 'should be able to add the ethernet network' do
    #   test = resourcetype.new(@client, name: resource['data']['name'])
    #   allow(resourcetype).to receive(:find_by).and_return([test])
    #   expect(provider.exists?).to eq(true)
    #   expect(provider.found).to eq(true)
    #   ethernet = OneviewSDK::EthernetNetwork.new(@client, name: 'Ethernet 1')
    #   allow_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:find_by).with(anything, name: 'Ethernet 1').and_return([ethernet])
    #   test['networkUris'] << ethernet['uri']
    #   expect_any_instance_of(OneviewSDK::Client).to receive(:rest_put).and_return(FakeResponse.new('Fake Get Statistics'))
    #   expect_any_instance_of(resourcetype).to receive(:update).and_return(FakeResponse.new('uri' => '/rest/fake'))
    #   allow(resourcetype).to receive(:set_native_network).with(ethernet).and_return(test)
    #   expect(provider.add_ethernet_network).to be
    # end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_network_set).new(
        name: 'Network Set',
        ensure: 'get_without_ethernet',
        data:
            {
              'name' => 'Network Set',
              'nativeNetwork' => 'Ethernet 1',
              'ethernetNetworks' => ['Ethernet 1']
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should require a data hash' do
      modified_config = lsg_config
      modified_config[:data] = ''
      resource_type = type_class.to_s.split('::')
      expect do
        type_class.new(modified_config)
      end.to raise_error(Puppet::Error, 'Parameter data failed on' \
      " #{resource_type[2]}[#{modified_config[:name]}]: Inserted value for data is not valid")
    end
  end
end
