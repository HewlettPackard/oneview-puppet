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
require File.expand_path(File.join(File.dirname(__FILE__), '../../../lib/puppet/provider/', 'login'))

provider_class = Puppet::Type.type(:oneview_uplink_set).provider(:c7000)
logical_interconnect_name = login[:logical_interconnect_name] || 'Encl1-Test Oneview'

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_uplink_set).new(
      name: 'Enclosure',
      ensure: 'present',
      data:
          {
            'name' => 'Puppet Uplink Set'
          },
      provider: 'c7000'
    )
  end

  before(:each) do
    provider.exists?
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters' do
    it 'should be an instance of the provider C7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_uplink_set).provider(:c7000)
    end

    it 'exists? should not find the uplink set' do
      expect(provider.exists?).not_to be
    end

    it 'should return that the uplink set was not found' do
      provider.exists?
      expect { provider.found }.to raise_error(/No UplinkSet with the specified data were found on the Oneview Appliance/)
    end
  end

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_uplink_set).new(
        name: 'Enclosure',
        ensure: 'present',
        data:
            {
              'nativeNetworkUri' => 'nil',
              'reachability' => 'Reachable',
              'logicalInterconnectUri' => logical_interconnect_name,
              'manualLoginRedistributionState' => 'NotSupported',
              'connectionMode' => 'Auto',
              'lacpTimer' => 'Short',
              'networkType' => 'Ethernet',
              'ethernetNetworkType' => 'Tagged',
              'description' => 'nil',
              'name' => 'Puppet Uplink Set'
            },
        provider: 'c7000'
      )
    end
    it 'should create the uplink set' do
      expect(provider.create).to be
    end
  end

  context 'given the uplink set was created' do
    it 'exists? should find the uplink set' do
      expect(provider.exists?).to be
    end
    it 'should return that the uplink set was found' do
      expect(provider.found).to be
    end

    it 'should drop the uplink set' do
      expect(provider.destroy).to be
    end
  end
end
