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

provider_class = Puppet::Type.type(:oneview_fabric).provider(:ruby)
resourcetype = OneviewSDK::Fabric

describe provider_class, unit: true do
  include_context 'shared context'

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_fabric).new(
        name: 'DefaultFabric',
        ensure: 'present',
        data:
            {
              'name' => 'DefaultFabric'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_fabric).provider(:ruby)
    end

    it 'should not be able to create a new fabric' do
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([])
      expect(provider.exists?).to eq(false)
      expect { provider.create }.to raise_error('This resource cannot be created.')
    end

    it 'should not be able to destroy the fabric' do
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([])
      expect(provider.exists?).to eq(false)
      expect { provider.destroy }.to raise_error('This resource cannot be destroyed.')
    end

    it 'should be able to return that the fabric exists' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect(provider.exists?).to eq(true)
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_fabric).new(
        name: 'DefaultFabric',
        ensure: 'found',
        data:
        {
          'name' => 'DefaultFabric'
        }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should return true if resource is found' do
      resource['data']['uri'] = '/rest/fabrics/fake'
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect(provider.exists?).to eq(true)
      expect(provider.found).to eq(true)
    end
  end
end
