################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

require 'spec_helper'
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_datacenter).provider(:ruby)
resourcetype = OneviewSDK::Datacenter

describe provider_class, unit: true do
  include_context 'shared context'

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_datacenter).new(
        name: 'Datacenter',
        ensure: 'present',
        data:
            {
              'name' => 'Datacenter',
              'width' => '5000',
              'depth' => '5000'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_datacenter).provider(:ruby)
    end

    it 'should return that the resource does not exists' do
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should be able to create the resource' do
      data = { 'name' => 'Datacenter', 'width' => '5000', 'depth' => '5000', 'contents' => [] }
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([])
      expect(provider.exists?).to eq(false)
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with('/rest/datacenters', { 'body' => data }, test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/datacenters/fake')
      expect(provider.create).to be
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_datacenter).new(
        name: 'Datacenter',
        ensure: 'found'
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should not return any datacenters' do
      allow(resourcetype).to receive(:find_by).with(anything, {}).and_return([])
      expect(provider.exists?).to eq(false)
      expect { provider.found }.to raise_error(/No Datacenter with the specified data were found on the Oneview Appliance/)
    end
  end

  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_datacenter).new(
        name: 'Datacenter',
        ensure: 'present',
        data:
            {
              'name' => 'Datacenter'
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    it 'should return that the resource exists' do
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      expect(provider.exists?).to eq(true)
    end

    it 'should be able to get the visual content' do
      visual_content = 'spec/support/fixtures/unit/provider/datacenter_visual_content.json'
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      expect(provider.exists?).to eq(true)
      allow_any_instance_of(resourcetype).to receive(:get_visual_content).and_return(File.read(visual_content))
      expect(provider.get_visual_content).to eq(true)
    end

    it 'should be able to remove the resource' do
      test = resourcetype.new(@client, name: resource['data']['name'])
      allow(resourcetype).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      expect(provider.exists?).to eq(true)
      allow_any_instance_of(resourcetype).to receive(:remove).and_return('Test')
      expect(provider.destroy).to be
    end
  end
end
