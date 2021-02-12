################################################################################
# (C) Copyright 2016-2020 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

require 'spec_helper'

provider_class = Puppet::Type.type(:oneview_fcoe_network).provider(:c7000)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:FCoENetwork, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context'

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_fcoe_network).new(
        name: 'FCoE Network',
        ensure: 'present',
        data:
            {
              'name' => 'Puppet Network',
              'vlanId' => 100,
              'connectionTemplateUri' => nil,
              'type' => 'fcoe-network'
            },
        provider: 'c7000'
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    let(:test) { resource_type.new(@client, resource['data']) }

    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_fcoe_network).provider(:c7000)
    end

    it 'runs through the create method' do
      allow(resource_type).to receive(:find_by).and_return([])
      allow_any_instance_of(resource_type).to receive(:create).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'should be able to run through self.instances' do
      allow(resource_type).to receive(:find_by).and_return([test])
      expect(instance).to be
    end

    it 'deletes the resource' do
      resource['data']['uri'] = '/rest/fake'
      test = resource_type.new(@client, resource['data'])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      allow(resource_type).to receive(:find_by).with(anything, 'name' => resource['data']['name']).and_return([test])
      expect_any_instance_of(resource_type).to receive(:delete).and_return({})
      provider.exists?
      expect(provider.destroy).to be
    end

    it 'should delete multiple uris' do
      resource['data']['uri'] = '/rest/fake'
      resource['data']['networkUris'] = %w(test1 test2)
      test = resource_type.new(@client, resource['data'])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
      allow_any_instance_of(resource_type).to receive(:bulk_delete).and_return({})
      expect(provider.bulk_delete_check).to be
      allow_any_instance_of(resource_type).to receive(:create).and_return(test)
    end
  end
end
