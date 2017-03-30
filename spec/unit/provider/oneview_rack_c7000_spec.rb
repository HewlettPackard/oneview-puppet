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

provider_class = Puppet::Type.type(:oneview_rack).provider(:c7000)
api_version = login[:api_version] || 300
resource_type = OneviewSDK.resource_named(:Rack, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_rack).new(
      name: 'rack',
      ensure: 'present',
      data:
          {
            'name' => 'myrack'
          },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  context 'given the minimum parameters' do
    before(:each) do
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_rack).provider(:c7000)
    end

    it 'should be able to find the resource' do
      provider.exists?
      expect(provider.found).to be
    end

    it 'should raise error when server is not found' do
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([])
      expect { provider.found }.to raise_error(/No Rack with the specified data were found on the Oneview Appliance/)
    end

    it 'should be able to add the resource' do
      allow(resource_type).to receive(:find_by).and_return([])
      allow_any_instance_of(resource_type).to receive(:add).and_return(resource_type.new(@client, resource['data']))
      expect(provider.exists?).to eq(false)
      expect(provider.create).to be
    end

    it 'should be able to run through self.instances' do
      allow(resource_type).to receive(:get_all).with(anything).and_return([test])
      expect(instance).to be
    end

    it 'should be able to run get_device_topology' do
      expect_any_instance_of(resource_type).to receive(:get_device_topology).and_return(['Fake Json'])
      expect(provider.get_device_topology).to be
    end
  end

  context 'given the rack resources' do
    let(:resource) do
      Puppet::Type.type(:oneview_rack).new(
        name: 'rack',
        ensure: 'present',
        data:
        {
          'name' => 'myrack',
          'rackMounts' => [
            { 'mountUri' => '/rest/enclosures/09SGH100X6J1', 'topUSlot' => 20, 'uHeight' => 10 }
          ]
        }
      )
    end
    before(:each) do
      resource['data']['uri'] = '/rest/fake'
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
    end
    it 'should be able to add a rack resource' do
      uri = { 'uri' => resource['data']['rackMounts'][0]['mountUri'] }
      new_res = Hash[resource['data']['rackMounts'][0].to_a]
      new_res.delete('mountUri')
      expect_any_instance_of(resource_type).to receive(:add_rack_resource).with(uri, new_res).and_return('test')
      expect_any_instance_of(resource_type).to receive(:update).and_return('test')
      expect(provider.add_rack_resource).to be
    end

    it 'should be able to remove a rack resource' do
      uri = { 'uri' => resource['data']['rackMounts'][0]['mountUri'] }
      expect_any_instance_of(resource_type).to receive(:remove_rack_resource).with(uri).and_return('test')
      expect_any_instance_of(resource_type).to receive(:update).and_return('test')
      expect(provider.remove_rack_resource).to be
    end

    it 'should allow specifying a name instead of an uri' do
      resource['data']['rackMounts'][0]['mountUri'] = 'Test, enclosure'
      allow(OneviewSDK::Enclosure).to receive(:find_by).with(anything, name: 'Test').and_return([test])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect(provider.exists?).to be
    end
  end

  context 'given the minimum parameters' do
    it 'should delete the rack' do
      resource['data']['uri'] = '/rest/fake/'
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.destroy).to be
    end
  end
end
