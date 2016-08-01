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

provider_class = Puppet::Type.type(:oneview_rack).provider(:ruby)

describe provider_class, unit: true do
  include_context 'shared context'

  @resourcetype = OneviewSDK::Rack
  let(:resource) do
    Puppet::Type.type(:oneview_rack).new(
      name: 'rack',
      ensure: 'present',
      data:
          {
            'name' => 'myrack'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters' do
    before(:each) do
      test = OneviewSDK::Rack.new(@client, resource['data'])
      allow(OneviewSDK::Rack).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_rack).provider(:ruby)
    end

    it 'should raise error when server is not found' do
      allow(OneviewSDK::Rack).to receive(:find_by).with(anything, resource['data']).and_return([])
      expect { provider.found }.to raise_error(/No Rack with the specified data were found on the Oneview Appliance/)
    end

    it 'should create/add the rack' do
      test = OneviewSDK::Rack.new(@client, resource['data'])
      allow(OneviewSDK::Rack).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
        .with('/rest/racks', anything, test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.create).to be
    end

    it 'should be able to run through self.instances' do
      test = OneviewSDK::Rack.new(@client, resource['data'])
      allow(OneviewSDK::Rack).to receive(:get_all).with(anything).and_return([test])
      expect(instance).to be
    end

    it 'should be able to run get_device_topology' do
      expect_any_instance_of(OneviewSDK::Rack).to receive(:get_device_topology).and_return(['Fake Json'])
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
      test = OneviewSDK::Rack.new(@client, resource['data'])
      allow(OneviewSDK::Rack).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
    end
    it 'should be able to add a rack resource' do
      uri = { 'uri' => resource['data']['rackMounts'][0]['mountUri'] }
      new_res = Hash[resource['data']['rackMounts'][0].to_a]
      new_res.delete('mountUri')
      expect_any_instance_of(OneviewSDK::Rack).to receive(:add_rack_resource).with(uri, new_res).and_return('test')
      expect_any_instance_of(OneviewSDK::Rack).to receive(:update).and_return('test')
      expect(provider.add_rack_resource).to be
    end

    it 'should be able to remove a rack resource' do
      uri = { 'uri' => resource['data']['rackMounts'][0]['mountUri'] }
      expect_any_instance_of(OneviewSDK::Rack).to receive(:remove_rack_resource).with(uri).and_return('test')
      expect_any_instance_of(OneviewSDK::Rack).to receive(:update).and_return('test')
      expect(provider.remove_rack_resource).to be
    end
  end

  context 'given the minimum parameters' do
    it 'should delete the rack' do
      resource['data']['uri'] = '/rest/fake/'
      test = OneviewSDK::Rack.new(@client, resource['data'])
      allow(OneviewSDK::Rack).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.destroy).to be
    end
  end
end
