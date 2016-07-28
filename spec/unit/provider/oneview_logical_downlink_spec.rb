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
module OneviewSDK
  # Logical downlink resource implementation
  class LogicalDownlink < Resource
    BASE_URI = '/rest/logical-downlinks'.freeze

    # Method is not available
    # @raise [OneviewSDK::MethodUnavailable] method is not available
    def create
      unavailable_method
    end

    # Method is not available
    # @raise [OneviewSDK::MethodUnavailable] method is not available
    def update
      unavailable_method
    end

    # Method is not available
    # @raise [OneviewSDK::MethodUnavailable] method is not available
    def delete
      unavailable_method
    end

    # Gets a list of logical downlinks, excluding any existing ethernet network
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @return [Array<OneviewSDK::LogicalDownlink] Logical downlink array
    def self.get_without_ethernet(client)
      result = []
      response = client.rest_get(BASE_URI + '/withoutEthernet')
      members = client.response_handler(response)['members']
      members.each { |member| result << new(client, member) }
      result
    end

    # Gets a logical downlink, excluding any existing ethernet network
    # @return [OneviewSDK::LogicalDownlink] Logical downlink array
    def get_without_ethernet
      response = @client.rest_get(@data['uri'] + '/withoutEthernet')
      OneviewSDK::LogicalDownlink.new(@client, @client.response_handler(response))
    end
  end
end
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
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      expect(provider.exists?).to eq(true)
    end

    it 'should not be able to create the resource' do
      allow(resourcetype).to receive(:create).and_return(false)
      expect(provider.create).to eq(false)
    end
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

    it 'should be able to get all the logical downlinks' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.found).to be
    end
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

    it 'should be able to get all the logical downlinks with no filters' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.found).to be
    end

    it 'should not be able to get all the logical downlinks' do
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should be able to get all the logical downlinks' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.found).to be
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
