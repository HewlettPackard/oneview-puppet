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

provider_class = Puppet::Type.type(:oneview_network_set).provider(:c7000)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:NetworkSet, api_version, :C7000)
ethernet_class = OneviewSDK.resource_named(:EthernetNetwork, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context'

  context 'given the standard parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_network_set).new(
        name: 'Network Set',
        ensure: 'present',
        data:
            {
              'name' => 'Network Set',
              'networkUris' => []
            },
        provider: 'c7000'
      )
    end

    let(:ethernet_resource) do
      Puppet::Type.type(:oneview_ethernet_network).new(
        name: 'ethernet',
        ensure: 'present',
        data:
            {
              'name'                    => 'EtherNetwork_Test1',
              'connectionTemplateUri'   => nil,
              'autoLoginRedistribution' => true,
              'vlanId'                  => '202'
            },
        provider: 'c7000'
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    let(:test) { resource_type.new(@client, name: resource['data']['name']) }

    let(:eth1) { ethernet_class.new(@client, name: ethernet_resource['data']) }

    before(:each) do
      resource['data']['networkUris'] = %w(Test1 Test2)
      allow(resource_type).to receive(:find_by).and_return([test])
      allow(ethernet_class).to receive(:find_by).and_return([eth1])
      allow_any_instance_of(ethernet_class).to receive(:create).and_return(eth1)
      provider.exists?
      provider.network_uris
      provider.native_network_uris
    end

    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_network_set).provider(:c7000)
    end

    it 'should return that the resource does not exists' do
      allow(resource_type).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should return that the resource exists' do
      expect(provider.found).to be
    end

    it 'should be able to create networks' do
      allow(ethernet_class).to receive(:create).and_return(ethernet_resource)
      expect(provider.exists?).to eq(true)
      expect(provider.create_networks).to be
      expect(ethernet_class.create).to be
    end

    it 'should be able to create the resource' do
      allow(resource_type).to receive(:find_by).and_return([])
      allow_any_instance_of(resource_type).to receive(:create).and_return(test)
      expect(provider.exists?).to eq(false)
      expect(provider.create).to be
    end

    it 'should be able to delete the resource' do
      resource['data']['uri'] = '/rest/fake'
      allow_any_instance_of(resource_type).to receive(:delete).and_return(true)
      expect(provider.destroy).to be
    end

    it 'should be able to get all the network sets without ethernet' do
      allow_any_instance_of(resource_type).to receive(:get_without_ethernet).and_return([test])
      expect(provider.get_without_ethernet).to be
    end
  end
  context 'given no data and the found ensure method' do
    ethernet_class = OneviewSDK.resource_named(:EthernetNetwork, api_version, :C7000)
    let(:resource1) do
      Puppet::Type.type(:oneview_network_set).new(
        name: 'Network Set',
        ensure: 'found',
        provider: 'c7000'
      )
    end

    let(:ethernet_resource1) do
      Puppet::Type.type(:oneview_ethernet_network).new(
        name: 'ethernet',
        ensure: 'present',
        data:
            {
              'name'                    => 'EtherNetwork_Test1',
              'connectionTemplateUri'   => nil,
              'autoLoginRedistribution' => true,
              'vlanId'                  => '202'

            },
        provider: 'c7000'
      )
    end

    let(:provider1) { resource1.provider }

    let(:test1) { resource_type.new(@client, {}) }

    let(:eth2) { ethernet_class.new(@client, name: ethernet_resource1['data']) }

    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test1])
      provider1.exists?
      allow(ethernet_class).to receive(:find_by).and_return([])
      allow(ethernet_class).to receive(:create).and_return(eth2)
      provider1.network_uris
      provider1.native_network_uris
    end

    it 'should be able to get all the network sets without ethernet' do
      allow(resource_type).to receive(:get_without_ethernet).and_return([test1])
      expect(provider.get_without_ethernet).to be
    end
  end
end
