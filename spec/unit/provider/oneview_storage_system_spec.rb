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

provider_class = Puppet::Type.type(:oneview_storage_system).provider(:oneview_storage_system)
resourcetype = OneviewSDK::StorageSystem

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_storage_system).new(
      name: 'Storage Pool',
      ensure: 'present',
      data:
          {
            'managedDomain' => 'TestDomain',
            'credentials' =>
            {
              'ip_hostname' => '172.18.11.12',
              'username' => 'dcs',
              'password' => 'dcs'
            }
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters' do
    before(:each) do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
    end

    it 'should be able to run through self.instances' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, {}).and_return([test])
      expect(instance).to be
    end

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_storage_system).provider(:oneview_storage_system)
    end

    it 'should able to find the resource' do
      expect(provider.found).to be
    end

    it 'should be able to delete the resource' do
      resource['data']['uri'] = '/rest/fake'
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      allow(resourcetype).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      provider.exists?
      expect(provider.destroy).to be
    end

    it 'should be able to get the storage pools' do
      allow_any_instance_of(resourcetype).to receive(:get_storage_pools).and_return('Test')
      expect(provider.get_storage_pools).to be
    end

    it 'should be able to get the managed ports' do
      allow_any_instance_of(resourcetype).to receive(:get_managed_ports).and_return('Test')
      expect(provider.get_managed_ports).to be
    end

    it 'should be able to get the storage pools' do
      allow(resourcetype).to receive(:get_host_types).and_return('Test')
      expect(provider.get_host_types).to be
    end

    # TODO: ArgumentError: Must specify a task_uri!
    # it 'should be able to create the resource' do
    #   data = { 'ip_hostname' => '172.18.11.12', 'username' => 'dcs', 'password' => 'dcs' }
    #   test = resourcetype.new(@client, resource['data'])
    #   allow(resourcetype).to receive(:find_by).and_return([])
    #   expect(provider.exists?).to eq(false)
    #   expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post)
    #     .with('/rest/storage-systems', { 'body' => data }, test.api_version).and_return(FakeResponse.new('uri' => '/rest/fake'))
    #   allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(uri: '/rest/storage-systems/fake')
    #   expect(provider.create).to be
    # end
  end
end
