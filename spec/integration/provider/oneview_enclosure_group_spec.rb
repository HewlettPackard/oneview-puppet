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

provider_class = Puppet::Type.type(:oneview_enclosure_group).provider(:oneview_enclosure_group)

describe provider_class, integration: true do
  let(:resource) do
    Puppet::Type.type(:oneview_enclosure_group).new(
      name: 'Enclosure Group',
      ensure: 'present',
      data:
        {
          'name' => 'Enclosure Group',
          'interconnectBayMappingCount' => 8,
          'stackingMode' => 'Enclosure'
        }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_enclosure_group).provider(:c7000)
  end

  context 'given the minimum parameters' do
    it 'exists? should not find an enclosure group' do
      expect(provider.exists?).not_to be
    end

    it 'should create a new enclosure group' do
      expect(provider.create).to be
    end
  end

  context 'given the unique resource id' do
    let(:resource) do
      Puppet::Type.type(:oneview_enclosure_group).new(
        name: 'Enclosure Group',
        ensure: 'present',
        data:
          {
            'name' => 'Enclosure Group'
          }
      )
    end

    it 'exists? should find an enclosure group' do
      expect(provider.exists?).to be
      expect(provider.found).to be
    end

    it 'should add the script to the enclosure group' do
      resource['data']['script'] = 'Sample'
      expect(provider.set_script).to be
    end

    it 'should display the script of the enclosure group' do
      expect(provider.get_script).to be
    end

    it 'should destroy the enclosure group' do
      expect(provider.destroy).to be
    end
  end
end
