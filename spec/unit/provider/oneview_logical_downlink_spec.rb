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
# support to the new version
require_relative 'logical_downlink'

provider_class = Puppet::Type.type(:oneview_logical_downlink).provider(:ruby)
resourcetype = OneviewSDK::LogicalDownlink

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_logical_downlink).new(
      name: 'Logical Downlink',
      ensure: 'present',
      data:
          {
            'name' => 'Logical Downlink',
            'logicalSwitchGroupUri' => '/rest/'
          }
    )
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_downlink).new(
        name: 'Logical Downlink',
        ensure: 'present',
        data:
            {
              'name' => 'Logical Downlink',
              'logicalSwitchGroupUri' => '/rest/'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_downlink).provider(:ruby)
    end

    it 'should return that the resource does not exist' do
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should return that the resource exists' do
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      expect(provider.exists?).to eq(true)
    end

    it 'should not be able to create the resource' do
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:create).and_return(false)
      expect(provider.create).to eq(false)
    end

    it 'should not be able to destroy the resource' do
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:destroy).and_return(false)
      expect(provider.create).to eq(false)
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_downlink).new(
        name: 'Logical Downlink',
        ensure: 'get_schema',
        data:
        {
          name: 'Logical Downlink'
        }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be able to get the logical downlink schema' do
      schema = 'spec/support/fixtures/unit/provider/logical_downlink_schema.json'
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect_any_instance_of(resourcetype).to receive(:schema).and_return(File.read(schema))
      expect(provider.exists?).to eq(true)
      expect(provider.get_schema).to eq(true)
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_downlink).new(
        name: 'Logical Downlink',
        ensure: 'get_logical_downlinks',
        data:
        {
          name: 'Logical Downlink'
        }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be able to get all the logical downlinks' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.get_logical_downlinks).to eq(true)
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_downlink).new(
        name: 'Logical Downlink',
        ensure: 'get_logical_downlinks',
        data:
        {
          name: 'Logical Downlink'
        }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be able to get all the logical downlinks with no filters' do
      data = {}
      test = resourcetype.new(@client, data)
      allow(resourcetype).to receive(:find_by).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.get_logical_downlinks).to eq(true)
    end

    it 'should not be able to get all the logical downlinks' do
      data = {}
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
      expect(provider.get_logical_downlinks).to eq(false)
    end

    it 'should be able to get all the logical downlinks' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.get_logical_downlinks).to eq(true)
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_downlink).new(
        name: 'Logical Downlink',
        ensure: 'get_without_ethernet',
        data:
        {
          name: 'Logical Downlink'
        }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should not be able to get the logical downlinks w/o ethernet' do
      data = {}
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
      expect(provider.get_without_ethernet).to eq(false)
    end

    # TODO: stuck at get_without_ethernet method
    # it 'should be able to get the logical downlinks w/o ethernet' do
    #   test = resourcetype.new(@client, resource['data'])
    #   allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
    #   expect(provider.exists?).to eq(true)
    #   new_test = resourcetype.new(@client, resource['data'])
    #   new_test.data['uri'] = "#{test.data['uri']}/withoutEthernet"
    #   allow(resourcetype).to receive(:get_without_ethernet).and_return([new_test])
    #   expect(provider.get_without_ethernet).to eq(true)
    # end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_downlink).new(
        name: 'Logical Downlink',
        ensure: 'found',
        data:
        {
          name: 'Logical Downlink'
        }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be able to find this logical downlink' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.found).to eq(true)
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_downlink).new(
        name: 'Logical Downlink',
      ensure: 'absent',
        data:
        {
          name: 'Logical Downlink'
        }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should not be able to delete this resource' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.destroy).to eq(false)
    end
  end
end
