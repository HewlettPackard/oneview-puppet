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

provider_class = Puppet::Type.type(:oneview_logical_downlink).provider(:oneview_logical_downlink)
resourcetype = OneviewSDK::LogicalDownlink

describe provider_class, unit: true do
  include_context 'shared context'

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_downlink).new(
        name: 'Logical Downlink',
        ensure: 'present',
        data:
            {
              'name' => 'Logical Downlink'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_downlink).provider(:oneview_logical_downlink)
    end

    it 'should not be able to create/destroy the resource' do
      expect { provider.create }.to raise_error('This resource relies on others to be created.')
      expect { provider.destroy }.to raise_error('This resource relies on others to be destroyed.')
    end

    it 'should be able to find the resource' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
      expect(provider.found).to be
    end

    it 'should be able to get all the logical downlinks without ethernet' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
      allow_any_instance_of(resourcetype).to receive(:get_without_ethernet).and_return(test)
      expect(provider.get_without_ethernet).to be
      allow(resourcetype).to receive(:get_without_ethernet).with(anything).and_return('')
      expect(provider.get_without_ethernet).to be
    end

    it 'should be able to get logical downlinks without ethernet' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
      allow_any_instance_of(resourcetype).to receive(:get_without_ethernet).and_return(test)
      expect(provider.get_without_ethernet).to be
      resource['data'] = {}
      allow(resourcetype).to receive(:get_without_ethernet).with(anything).and_return(test)
      expect(provider.get_without_ethernet).to be
    end
  end
end
