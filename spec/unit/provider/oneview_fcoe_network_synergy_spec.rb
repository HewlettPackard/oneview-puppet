################################################################################
# (C) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
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

provider_class = Puppet::Type.type(:oneview_fcoe_network).provider(:synergy)
api_version = login[:api_version] || 200

describe provider_class, unit: true, if: api_version >= 300 do
  include_context 'shared context'

  resourcetype = OneviewSDK.resource_named(:FCoENetwork, api_version, 'Synergy')

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
        provider: 'synergy'
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    let(:test) { resourcetype.new(@client, resource['data']) }

    before(:each) do
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_fcoe_network).provider(:synergy)
    end

    it 'runs through the create method' do
      allow(resourcetype).to receive(:find_by).and_return([])
      allow_any_instance_of(resourcetype).to receive(:create).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'should be able to run through self.instances' do
      allow(resourcetype).to receive(:find_by).and_return([test])
      expect(instance).to be
    end

    it 'deletes the resource' do
      resource['data']['uri'] = '/rest/fake'
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      allow(resourcetype).to receive(:find_by).with(anything, 'name' => resource['data']['name']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      provider.exists?
      expect(provider.destroy).to be
    end
  end
end
