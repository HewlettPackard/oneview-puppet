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

provider_class = Puppet::Type.type(:oneview_storage_system).provider(:ruby)

describe provider_class do

  let(:resource) {
    Puppet::Type.type(:oneview_storage_system).new(
      name: 'Enclosure',
      ensure: 'present',
        data:
          {
            'credentials'   => {
              'ip_hostname' => '172.18.11.11',
            }
          },
    )
  }

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters' do

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_storage_system).provider(:ruby)
    end

    it 'exists? should not find the storage system' do
      expect(provider.exists?).not_to be
    end

    it 'should return that the storage system was not found' do
      expect(provider.found).not_to be
    end

    it 'should not be able to get the storage pools from the storage system' do
      expect(provider.get_storage_pools).not_to be
    end

    it 'should not be able to get the managed ports from the storage system' do
      expect(provider.get_managed_ports).not_to be
    end

    it 'should not be able to get the host types from the storage system' do
      expect(provider.get_host_types).not_to be
    end

  end

  context 'given the create parameters' do
    let(:resource) {
      Puppet::Type.type(:oneview_storage_system).new(
        name: 'Enclosure',
        ensure: 'present',
          data:
            {
              'name'         => 'OneViewSDK Test Storage System',
              'managedDomain' => 'TestDomain',
              'credentials'   => {
                'ip_hostname' => '172.18.11.11',
                'username'     => 'dcs',
                'password'     => 'dcs',
              }
            },
      )
    }

    # TODO Create block
    it 'should create the storage system' do
      expect(provider.create).to be
    end

  end

  context 'given the minimum parameters' do
    it 'exists? should find the storage system' do
      expect(provider.exists?).to be
    end
    it 'should return that the storage system was found' do
      expect(provider.found).to be
    end

    it 'should be able to get the storage pools from the storage system' do
      expect(provider.get_storage_pools).to be
    end

    it 'should be able to get the managed ports from the storage system' do
      expect(provider.get_managed_ports).to be
    end

    it 'should be able to get the host types from the storage system' do
      expect(provider.get_host_types).to be
    end

    it 'should drop the storage system' do
      expect(provider.destroy).to be
    end

  end

end
