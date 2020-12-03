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
api_version_check = 1800
resource_type = OneviewSDK.resource_named(:StoragePool, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context'

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

  let(:resource_manage) do
    Puppet::Type.type(:oneview_storage_pool).new(
      name: 'Storage Pool',
      ensure: 'manage',
      data:
          {
            'isManaged'        => 'true',
            'name'             => 'cpg-growth-limit-1TiB',
            'storageSystemUri' => ''
          },
      provider: 'c7000'
    )
  end

  resource_types = OneviewSDK.resource_named(:StorageSystem, api_version, :C7000)

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  let(:condition) { api_version_check >= 500 }

  context 'given the minimum parameters' do
    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
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
      expect(condition).to be false
      allow(resource_type).to receive(:find_by).and_return([])
      allow_any_instance_of(resource_type).to receive(:retrieve!).and_return(false)
      expect_any_instance_of(resource_type).to receive(:add).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'should be able to destroy and recreate the resource to update its atributes' do
      expect(condition).to be false
      expect(resource_type).to receive(:find_by).and_return([test])
      allow_any_instance_of(resource_type).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(resource_type).to receive(:remove).and_return(true)
      allow_any_instance_of(resource_type).to receive(:add).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'should be able to edit the state of the resource' do
      expect(condition).to be true
      allow(resource_types).to receive(:get_all).and_return([test_manage])
      allow_any_instance_of(resource_type).to receive(:manage).and_return(true)
      allow(resource_type).to receive(:set_storage_system).and_return(test_manage)
      expect(provider.manage).to be
    end

    it 'should be able to get all reachable pools' do
      expect(condition).to be true
      allow(resource_types).to receive(:get_all).and_return([test])
      allow(resource_type).to receive(:reachable).and_return(true)
      allow(resource_type).to receive(:set_storage_system).and_return(test)
      expect(provider.reachable).to be
    end

    it 'should delete the resource' do
      expect(condition).to be false
      allow_any_instance_of(resource_type).to receive(:remove).and_return([])
      expect(provider.destroy).to be
    end
  end
end
