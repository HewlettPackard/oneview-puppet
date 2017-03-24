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

provider_class = Puppet::Type.type(:oneview_storage_pool).provider(:synergy)
api_version = login[:api_version] || 200
resourcetype = OneviewSDK.resource_named(:StoragePool, api_version, 'Synergy')

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
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resourcetype.new(@client, resource['data']) }

  context 'given the minimum parameters' do
    before(:each) do
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should be an instance of the provider synergy' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_storage_pool).provider(:synergy)
    end

    it 'should able to find the resource' do
      expect(provider.found).to be
    end

    it 'should be able to create the resource' do
      allow(resourcetype).to receive(:find_by).and_return([])
      expect_any_instance_of(resourcetype).to receive(:retrieve!).and_return(false)
      expect_any_instance_of(resourcetype).to receive(:add).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'should be able to destroy and recreate the resource to update its atributes' do
      expect(resourcetype).to receive(:find_by).and_return([])
      expect(resourcetype).to receive(:find_by).and_return([test])
      allow_any_instance_of(resourcetype).to receive(:remove).and_return(true)
      expect_any_instance_of(resourcetype).to receive(:retrieve!).and_return(false)
      allow_any_instance_of(resourcetype).to receive(:add).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'should delete the resource' do
      allow_any_instance_of(resourcetype).to receive(:remove).and_return([])
      expect(provider.destroy).to be
    end
  end
end
