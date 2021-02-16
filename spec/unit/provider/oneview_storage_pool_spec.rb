################################################################################
# (C) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
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

provider_class = Puppet::Type.type(:oneview_storage_pool).provider(:c7000)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:StoragePool, api_version, :C7000)
system_type = OneviewSDK.resource_named(:StorageSystem, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context'
  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_storage_pool).new(
        name: 'Storage Pool',
        ensure: 'present',
        data:
            {
              'name' => 'PDU 1',
              'poolName' => 'CPG-SSD-AO',
              'storageSystemUri' => '/rest/'
            },
        provider: 'c7000'
      )
    end

    let(:system_resource) do
      Puppet::Type.type(:oneview_storage_system).new(
        name: 'ThREEPAR-1',
        ensure: 'present',
        data:
            {
              'managedDomain' => 'TestDomain',
              'credentials' =>
              {
                'ip_hostname' => '<hostname>',
                'username' => '<username>',
                'password' => '<password>'
              }
            },
        provider: 'c7000'
      )
    end

    let(:resource) do
      Puppet::Type.type(:oneview_storage_pool).new(
        name: 'Storage Pool',
        ensure: 'present',
        data:
            {
              'name' => '172.18.8.11, PDU 1',
              'poolName' => 'CPG-SSD-AO',
              'storageSystemUri' => '/rest/'
            },
        provider: 'c7000'
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    let(:test) { resource_type.new(@client, resource['data']) }

    let(:system_test) { system_type.new(@client, resource['data']) }

    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      allow(system_type).to receive(:find_by).and_return([system_test])
      provider.exists?
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_storage_pool).provider(:c7000)
    end

    it 'should able to find the resource' do
      expect(provider.found).to be
    end

    it 'should be able to create the resource' do
      allow(resource_type).to receive(:find_by).and_return([])
      allow_any_instance_of(resource_type).to receive(:retrieve!).and_return(false)
      expect_any_instance_of(resource_type).to receive(:add).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'should be able to destroy and recreate the resource to update its atributes' do
      expect(resource_type).to receive(:find_by).and_return([test])
      allow_any_instance_of(resource_type).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(resource_type).to receive(:remove).and_return(true)
      allow_any_instance_of(resource_type).to receive(:add).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'should be able to edit the state of the resource' do
      provider.manage
    end

    it 'should be able to get all reachable pools' do
      allow(resource_type).to receive(:reachable).and_return([])
      provider.reachable
    end

    it 'should delete the resource' do
      allow_any_instance_of(resource_type).to receive(:remove).and_return([])
      expect(provider.destroy).to be
    end
  end
end
