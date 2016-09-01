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
require File.expand_path(File.join(File.dirname(__FILE__), '../../../lib/puppet/provider/', 'login'))

provider_class = Puppet::Type.type(:oneview_volume).provider(:ruby)
storage_pool_name = login[:storage_pool_name] || '/rest/storage-pools/A42704CB-CB12-447A-B779-6A77ECEEA77D'

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_volume).new(
      name: 'Enclosure',
      ensure: 'present',
      data:
            {
              'name' => 'ONEVIEW_SDK_TEST_VOLUME_1'
            }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  context 'given the minimum parameters' do
    it 'should be an instance of the provider oneview_volume' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_volume).provider(:oneview_volume)
    end

    it 'should not exist until it is created' do
      expect(provider.exists?).not_to be
    end

    it 'should return that the volume was not found' do
      expect { provider.found }.to raise_error(/No Volume with the specified data were found on the Oneview Appliance/)
    end

    it 'should return that the get_attachable_volumes was not found' do
      expect(provider.get_attachable_volumes).to be
    end

    it 'should return that the get_extra_managed_volume_paths was not found' do
      expect(provider.get_extra_managed_volume_paths).to be
    end
  end

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_volume).new(
        name: 'Enclosure',
        ensure: 'present',
        data:
              {
                'name'                   => 'ONEVIEW_SDK_TEST_VOLUME_1',
                'description'            => 'Test volume with common creation: Storage System + Storage Pool',
                'provisioningParameters' => {
                  'provisionType'     => 'Full',
                  'shareable'         => true,
                  'requestedCapacity' => 1024 * 1024 * 1024,
                  'storagePoolUri'    => storage_pool_name
                },
                'snapshotPoolUri' => storage_pool_name
              }
      )
    end

    it 'should create the storage system' do
      expect(provider.create).to be
    end
  end

  context 'given the snapshotParameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_volume).new(
        name: 'Enclosure',
        ensure: 'present',
        data:
              {
                'name' => 'ONEVIEW_SDK_TEST_VOLUME_1',
                'snapshotParameters' => {
                  'name' => 'test_snapshot',
                  'type' => 'Snapshot',
                  'description' => 'New snapshot'
                }
              }
      )
    end

    it 'should be able to create a snapshot' do
      expect(provider.create_snapshot).to be
    end

    it 'should be able to get a snapshot' do
      expect(provider.get_snapshot).to be
    end

    it 'should be able to delete a snapsho' do
      expect(provider.delete_snapshot).to be
    end
  end

  context 'given the minimum parameters' do
    it 'should exist now that it was created' do
      expect(provider.exists?).to be
    end

    it 'should return that the volume was found' do
      expect(provider.found).to be
    end
    it 'should drop the volume' do
      expect(provider.destroy).to be
    end
  end
end
