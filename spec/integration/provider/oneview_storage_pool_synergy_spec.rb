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

# NOTE: This resource requires a storage system to be added to the appliance and
# adds the specified storage pool

require 'spec_helper'
require_relative '../../../lib/puppet/provider/login'

provider_class = Puppet::Type.type(:oneview_storage_pool).provider(:synergy)
storage_pool_name = login[:storage_pool_name] || 'FST_CPG2'
storage_system_name = login[:storage_system_name] || 'ThreePAR7200-8147'

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_storage_pool).new(
      name: 'Storage Pool',
      ensure: 'present',
      data:
          {
            'poolName' => storage_pool_name
          },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  context 'given the minimum parameters' do
    it 'should be an instance of the provider synergy' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_storage_pool).provider(:synergy)
    end

    it 'exists? should not find the storage pool' do
      expect(provider.exists?).not_to be
    end

    it 'should return that the storage pool was not found' do
      expect { provider.found }.to raise_error(/No StoragePool with the specified data were found on the Oneview Appliance/)
    end
  end

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_storage_pool).new(
        name: 'Storage Pool',
        ensure: 'present',
        data:
            {
              'poolName'          => storage_pool_name,
              'storageSystemUri'  => storage_system_name
            },
        provider: 'synergy'
      )
    end

    it 'should create the storage pool' do
      expect(provider.create).to be
    end
  end

  context 'given the minimum parameters' do
    it 'exists? should find the storage pool' do
      expect(provider.exists?).to be
    end
    it 'should return that the storage pool was found' do
      expect(provider.found).to be
    end

    it 'should drop the storage pool' do
      expect(provider.destroy).to be
    end
  end
end
