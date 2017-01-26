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

provider_class = Puppet::Type.type(:oneview_sas_logical_interconnect_group).provider(:synergy)
api_version = login[:api_version] || 300
resource_name = 'SASLogicalInterconnectGroup'
resourcetype ||= Object.const_get("OneviewSDK::API#{api_version}::Synergy::#{resource_name}") unless login[:api_version] == 200

describe provider_class, unit: true, if: login[:api_version] >= 300 do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_sas_logical_interconnect_group).new(
      name: 'Test LIG',
      ensure: 'present',
      data:
       {
         'name'          => 'Puppet Unit SAS LIG',
         'interconnects' =>
        [
          {
            'bay'  => 1,
            'type' => 'Synergy 12Gb SAS Connection Module'
          },
          {
            'bay'  => 4,
            'type' => 'Synergy 12Gb SAS Connection Module'
          }
        ]
       },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resourcetype.new(@client, resource['data']) }

  context 'given the min parameters' do
    before(:each) do
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider synergy' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_sas_logical_interconnect_group).provider(:synergy)
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'runs through the create method' do
      allow(resourcetype).to receive(:find_by).and_return([])
      allow_any_instance_of(resourcetype).to receive(:add_interconnect).and_return('')
      allow_any_instance_of(resourcetype).to receive(:create).and_return(test)
      expect(provider.create).to be
    end

    it 'should be able to find the resource' do
      expect(provider.found).to be
    end

    it 'deletes the resource' do
      expect_any_instance_of(resourcetype).to receive(:delete).and_return(true)
      expect(provider.destroy).to be
    end
  end
end
