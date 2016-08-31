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

provider_class = Puppet::Type.type(:oneview_storage_system).provider(:oneview_storage_system)
storage_system_name = login[:storage_system_name] || 'ThreePAR7200-8147'
storage_system_ip = login[:storage_system_ip] || '172.18.11.12'
storage_system_username = login[:storage_system_username] || 'dcs'
storage_system_password = login[:storage_system_password] || 'dcs'
storage_system_domain = login[:storage_system_domain] || 'TestDomain'

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_storage_system).new(
      name: 'Enclosure',
      ensure: 'present',
      data:
          {
            'credentials'   => {
              'ip_hostname' => storage_system_ip
            }
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  context 'given the minimum parameters' do
    it 'should be an instance of the provider oneview_storage_system' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_storage_system).provider(:oneview_storage_system)
    end

    it 'exists? should not find the storage system' do
      expect(provider.exists?).not_to be
    end

    it 'should return that the storage system was not found' do
      expect { provider.found }.to raise_error(/No StorageSystem with the specified data were found on the Oneview Appliance/)
    end

    it 'should not be able to get the storage pools from the storage system' do
      expect { provider.get_storage_pools }.to raise_error(
        /No resources with the specified data specified were found. Specify a valid unique identifier on data./
      )
    end

    it 'should not be able to get the managed ports from the storage system' do
      expect { provider.get_managed_ports }.to raise_error(
        /No resources with the specified data specified were found. Specify a valid unique identifier on data./
      )
    end
  end

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_storage_system).new(
        name: 'Enclosure',
        ensure: 'present',
        data:
            {
              'name' => storage_system_name,
              'managedDomain' => storage_system_domain,
              'credentials'   => {
                'ip_hostname' => storage_system_ip,
                'username'     => storage_system_username,
                'password'     => storage_system_password
              }
            }
      )
    end

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
