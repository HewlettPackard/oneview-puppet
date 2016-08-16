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

provider_class = Puppet::Type.type(:oneview_storage_pool).provider(:oneview_storage_pool)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_storage_pool).new(
      name: 'Storage Pool',
      ensure: 'present',
      data:
          {
            'poolName' => 'FST_CPG2'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters' do
    it 'should be an instance of the provider oneview_storage_pool' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_storage_pool).provider(:oneview_storage_pool)
    end

    it 'exists? should not find the storage pool' do
      expect(provider.exists?).not_to be
    end

    it 'should return that the storage pool was not found' do
      expect(provider.found).not_to be
    end
  end

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_storage_pool).new(
        name: 'Storage Pool',
        ensure: 'present',
        data:
            {
              'poolName'          => 'FST_CPG2',
              'storageSystemUri'  => '/rest/storage-systems/TXQ1000307'
            }
      )
    end

    # TODO: Create block
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
