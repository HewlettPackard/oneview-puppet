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
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_storage_system).provider(:oneview_storage_system)
api_version = login[:api_version] || 200
resource_name = 'StorageSystem'
resource_type = if api_version == 200
                  Object.const_get("OneviewSDK::API#{api_version}::#{resource_name}")
                else
                  Object.const_get("OneviewSDK::API#{api_version}::C7000::#{resource_name}")
                end

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
          },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  context 'given the minimum parameters' do
    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_storage_system).provider(:c7000)
    end

    it 'should able to find the resource' do
      expect(provider.found).to be
    end

    it 'should be able to delete the resource' do
      allow_any_instance_of(resource_type).to receive(:remove).and_return([])
      provider.exists?
      expect(provider.destroy).to be
    end

    it 'should be able to get the storage pools' do
      allow_any_instance_of(resource_type).to receive(:get_storage_pools).and_return('Test')
      expect(provider.get_storage_pools).to be
    end

    it 'should be able to get the managed ports' do
      allow_any_instance_of(resource_type).to receive(:get_managed_ports).and_return('Test')
      expect(provider.get_managed_ports).to be
    end

    it 'should be able to get the storage pools' do
      allow(resource_type).to receive(:get_host_types).and_return('Test')
      expect(provider.get_host_types).to be
    end

    it 'should be able to create the resource' do
      allow(resource_type).to receive(:find_by).and_return([])
      allow_any_instance_of(resource_type).to receive(:add).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end
  end
end
