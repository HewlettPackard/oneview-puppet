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

provider_class = Puppet::Type.type(:oneview_ethernet_network).provider(:ruby)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_ethernet_network).new(
      name: 'ethernet',
      ensure: 'present',
      data:
          {
            'name' => 'Puppet Network',
            'vlanId' => 100,
            'purpose' => 'General',
            'smartLink' => 'false',
            'privateNetwork' => 'true',
            'connectionTemplateUri' => 'nil',
            'type' => 'ethernet-networkV3'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_ethernet_network).provider(:ruby)
  end

  context 'given the minimum parameters' do
    it 'exists? that the network does not exist' do
      expect(provider.exists?).not_to be
    end

    it 'should create the network' do
      expect(provider.create).to be
    end
  end

  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_ethernet_network).new(
        name: 'ethernet',
        ensure: 'present',
        data:
            {
              'name' => 'Puppet Network'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    before(:each) do
      provider.exists?
    end

    it 'exists? should return the found networks' do
      expect(provider.found).to be
    end

    it 'should destroy the network' do
      expect(provider.destroy).to be
    end
  end
end
