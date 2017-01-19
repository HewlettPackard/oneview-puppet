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

provider_class = Puppet::Type.type(:oneview_storage_pool).provider(:oneview_storage_pool)
resourcetype = OneviewSDK::StoragePool

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
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters' do
    before(:each) do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
    end

    it 'should be able to run through self.instances' do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, {}).and_return([test])
      expect(instance).to be
    end

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_storage_pool).provider(:oneview_storage_pool)
    end

    it 'should able to find the resource' do
      expect(provider.found).to be
    end

    it 'should be able to create the resource' do
      allow(resourcetype).to receive(:find_by).and_return([])
      allow_any_instance_of(resourcetype).to receive(:add).and_return(resourcetype.new(@client, resource['data']))
      expect(provider.exists?).to eq(false)
      expect(provider.create).to be
    end

    it 'should delete the resource' do
      resource['data']['uri'] = '/rest/fake/'
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.destroy).to be
    end
  end
end
