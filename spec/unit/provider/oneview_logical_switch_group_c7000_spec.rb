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
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_logical_switch_group).provider(:c7000)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:LogicalSwitchGroup, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context'
  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_switch_group).new(
        name: 'LSG',
        ensure: 'present',
        data:
            {
              'name' => 'OneViewSDK Test Logical Switch Group',
              'category' => 'logical-switch-groups',
              'state' => 'Active',
              'switches' =>
              {
                'number_of_switches' => '1',
                'type' => 'Cisco Nexus 50xx'
              }
            },
        provider: 'c7000'
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    let(:test) { resource_type.new(@client, resource['data']) }

    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_switch_group).provider(:c7000)
    end

    it 'should be able to find the connection template' do
      expect(provider.found).to be
    end

    it 'should be able to delete the resource' do
      allow_any_instance_of(resource_type).to receive(:delete).and_return(true)
      expect(provider.destroy).to be
    end

    it 'should be able to find the resource' do
      expect(provider.found).to be
    end

    it 'successfully runs through the create method' do
      allow(resource_type).to receive(:find_by).and_return([])
      allow_any_instance_of(resource_type).to receive(:set_grouping_parameters).with(1, 'Cisco Nexus 50xx').and_return(test)
      allow_any_instance_of(resource_type).to receive(:create).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end
  end
end
