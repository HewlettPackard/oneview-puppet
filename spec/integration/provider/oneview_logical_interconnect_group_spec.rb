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

provider_class = Puppet::Type.type(:oneview_logical_interconnect_group).provider(:ruby)

describe provider_class do

  let(:resource) {
    Puppet::Type.type(:oneview_logical_interconnect_group).new(
      name: 'Test LIG',
    ensure: 'present',
        data:
          {
              'name'                    => 'Test LIG',
              'enclosureType'           => 'C7000',
              'type'                    => 'logical-interconnect-groupV3'
          },
    )
  }

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_interconnect_group).provider(:ruby)
  end

  context 'given the minimum parameters' do

    it 'should not be able to find the logical interconnect group' do
      expect(provider.found).not_to be
    end

    it 'should create the logical interconnect group' do
      expect(provider.create).to be
    end

    it 'should be able to find the logical interconnect group' do
      expect(provider.found).to be
    end

    it 'should be able to get the schema' do
      expect(provider.get_schema).to be
    end

    it 'should be able to get the default settings' do
      expect(provider.get_default_settings).to be
    end

    it 'should be able to get the settings' do
      expect(provider.get_settings).to be
    end

    it 'should be able to delete the logical interconnect group' do
      expect(provider.destroy).to be
    end
  end
end
