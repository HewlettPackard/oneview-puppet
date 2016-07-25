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

provider_class = Puppet::Type.type(:oneview_network_set).provider(:ruby)

describe provider_class do
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

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  context 'given the minimum parameters' do
    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_network_set).provider(:ruby)
    end

    it 'should not be able to find this resource before it has been created' do
      expect(provider.exists?).not_to be
      expect { provider.found }.to raise_error(Puppet::Error, 'The Network Set does not exists.')
    end

    it 'should be able to create the resource' do
      expect(provider.create).to be
    end

    it 'should be able to get the resource without ethernet' do
      expect(provider.get_without_ethernet).to be
    end

    it 'should not be able to find this resource' do
      expect(provider.exists?).to be
      expect(provider.found).to be
    end

    it 'should be able to set the native network' do
      expect(provider.set_native_network).to be
    end

    it 'should be able to add a network' do
      expect(provider.add_ethernet_network).to be
    end

    it 'should be able to delete the resource' do
      expect(provider.destroy).to be
    end
  end

  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_network_set).new(
        name: 'Network Set',
        ensure: 'get_schema'
      )
    end

    it 'should be able to get the schema' do
      expect(provider.get_schema).to be
    end
  end

  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_network_set).new(
        name: 'Network Set',
        ensure: 'get_network_sets'
      )
    end

    it 'should be able to get all the network sets' do
      expect(provider.get_network_sets).to be
    end
  end
end
