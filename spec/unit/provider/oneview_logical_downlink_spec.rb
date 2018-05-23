################################################################################
# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
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

provider_class = Puppet::Type.type(:oneview_logical_downlink).provider(:c7000)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:LogicalDownlink, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_logical_downlink).new(
      name: 'Logical Downlink',
      ensure: 'present',
      data:
          {
            'name' => 'Logical Downlink'
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

  context 'given the min parameters' do
    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_downlink).provider(:c7000)
    end

    it 'should not be able to create/destroy the resource' do
      expect { provider.create }.to raise_error('This resource relies on others to be created.')
      expect { provider.destroy }.to raise_error('This resource relies on others to be destroyed.')
    end

    it 'should be able to find the resource' do
      expect(provider.found).to be
    end
  end

  context '#get without ethernet for API 300 onwards', if: login[:api_version] >= 300 do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_downlink).new(
        name: 'Logical Downlink',
        ensure: 'get_without_ethernet',
        data:
            {
              'name' => 'Logical Downlink'
            },
        provider: 'c7000'
      )
    end

    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should raise error when running get without ethernet' do
      expect { provider.get_without_ethernet }.to raise_error(/The method #get_without_ethernet is unavailable for this resource/)
    end

    it 'should raise error when running get without ethernet' do
      resource['data'] = {}
      provider.exists?
      expect { provider.get_without_ethernet }.to raise_error(/The method #self.get_without_ethernet is unavailable for this resource/)
    end
  end

  context 'for API 200' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_downlink).new(
        name: 'Logical Downlink',
        ensure: 'get_without_ethernet',
        data:
            {
              'name' => 'Logical Downlink'
            },
        provider: 'c7000'
      )
    end

    it 'should be able to get logical downlinks without ethernet' do
      allow_any_instance_of(resource_type).to receive(:get_without_ethernet).and_return(test)
      expect(provider.get_without_ethernet).to be
    end

    it 'should be able to get all the logical downlinks without ethernet' do
      allow(resource_type).to receive(:get_without_ethernet).and_return([test])
      resource['data'] = {}
      provider.exists?
      expect(provider.get_without_ethernet).to be
    end
  end
end
