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
storage_class = OneviewSDK.resource_named(:StorageSystem, api_version, :C7000)

describe provider_class, unit: true, if: api_version >= 500 do
  include_context 'shared context'

  let(:resource) do
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

  let(:storage_system) do
    Puppet::Type.type(:oneview_storage_system).new(
      name: 'Storage System',
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
          },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  let(:storage_test) { storage_class.new(@client, name: storage_system['data']) }

  context 'given the minimum parameters' do
    before(:each) do
      resource['data']['storageSystemUri'] = '/rest/fake'
      allow(resource_type).to receive(:find_by).and_return([test])
      allow(sp_class).to receive(:find_by).and_return([storage_test])
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

    it 'should be able to edit the state of the resource' do
      allow_any_instance_of(resource_type).to receive(:manage).and_return(true)
      provider.manage
      expect(provider.set_storage_system).to be
    end

    it 'should be able to get all reachable pools' do
      allow(resource_type).to receive(:reachable).and_return(true)
      provider.reachable
      expect(provider.set_storage_system).to be
    end
  end
end

