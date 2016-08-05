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

provider_class = Puppet::Type.type(:oneview_logical_switch_group).provider(:ruby)
resourcetype = OneviewSDK::LogicalSwitchGroup

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_logical_switch_group).new(
      name: 'LSG',
      ensure: 'present',
      data:
          {
            'name' => 'OneViewSDK Test Logical Switch Group',
            'category' => 'logical-switch-groups',
            'state' => 'Active',
            'type' => 'logical-switch-group',
            'switches' =>
            {
              'number_of_switches' => '1',
              'type' => 'Cisco Nexus 50xx'
            }
          }
    )
  end

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
              'type' => 'logical-switch-group',
              'switches' =>
              {
                'number_of_switches' => '1',
                'type' => 'Cisco Nexus 50xx'
              }
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_switch_group).provider(:ruby)
    end

    it 'return false when the resource does not exists' do
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should be able to find the connection template' do
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.found).to be
    end

    # TODO: find out how to stub response
    # it 'should be able to create the resource' do
    #   data = resource['data']
    #   allow_any_instance_of(resourcetype).to receive(:retrieve!).and_return(false)
    #   allow_any_instance_of(resourcetype).to receive(:exists?).and_return(false)
    #   expect(provider.exists?).to eq(false)
    #   allow_any_instance_of(resourcetype).to receive(:set_grouping_parameters)
    #     .with(switches['groupingParameters'].keys[0].to_i, switches['groupingParameters'].values[0])
    #     .and_return(true)
    #   data.delete('switches')
    #   # expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
    #   #   .with('/rest/logical-switch-groups', { 'body' => data }, test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
    #   # allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/logical-switch-groups/100')
    #   # expect(provider.create).to eq(true)
    # end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_switch_group).new(
        name: 'LSG',
        ensure: 'found',
        data:
            {
              'name' => 'OneViewSDK Test Logical Switch Group',
              'category' => 'logical-switch-groups',
              'state' => 'Active',
              'type' => 'logical-switch-group',
              'switches' =>
              {
                'number_of_switches' => '1',
                'type' => 'Cisco Nexus 50xx'
              }
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be able to find the resource' do
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.found).to be
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_switch_group).new(
        name: 'LSG',
        ensure: 'present',
        data:
            {
              'name' => 'OneViewSDK Test Logical Switch Group'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be able to delete the resource' do
      resource['data']['uri'] = '/rest/fake'
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      allow(resourcetype).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      provider.exists?
      expect(provider.destroy).to be
    end
  end
end
