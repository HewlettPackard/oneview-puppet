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

provider_class = Puppet::Type.type(:oneview_ethernet_network).provider(:synergy)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:EthernetNetwork, api_version, :Synergy)

describe provider_class, unit: true, if: api_version >= 300 do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_ethernet_network).new(
      name: 'Ethernet Network',
      ensure: 'present',
      data:
          {
            'name' => 'Puppet Network',
            'vlanId' => 100,
            'purpose' => 'General',
            'smartLink' => 'false',
            'privateNetwork' => 'true',
            'connectionTemplateUri' => nil,
            'type' => 'ethernet-networkV3'
          },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  context 'given the create parameters' do
    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider synergy' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_ethernet_network).provider(:synergy)
    end

    it 'runs through the create method' do
      allow(resource_type).to receive(:find_by).and_return([])
      allow_any_instance_of(resource_type).to receive(:create).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'deletes the resource' do
      resource['data']['uri'] = '/rest/fake'
      test = resource_type.new(@client, resource['data'])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      provider.exists?
      expect(provider.destroy).to be
    end

    it 'should be able to get the associated uplink groups' do
      resource['data']['uri'] = '/rest/fake'
      test = resource_type.new(@client, resource['data'])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
      allow_any_instance_of(resource_type).to receive(:get_associated_uplink_groups).and_return('Test')
      expect(provider.get_associated_uplink_groups).to be
    end

    it 'should raise a warning when there are no associated uplink groups to show' do
      resource['data']['uri'] = '/rest/fake'
      test = resource_type.new(@client, resource['data'])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
      allow_any_instance_of(resource_type).to receive(:get_associated_uplink_groups).and_return('[]')
      expect(provider.get_associated_uplink_groups).to be
    end

    it 'should be able to get the associated profiles' do
      resource['data']['uri'] = '/rest/fake'
      test = resource_type.new(@client, resource['data'])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
      allow_any_instance_of(resource_type).to receive(:get_associated_profiles).and_return('Test')
      expect(provider.get_associated_profiles).to be
    end

    it 'should be able to get the associated profiles' do
      resource['data']['uri'] = '/rest/fake'
      test = resource_type.new(@client, resource['data'])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
      allow_any_instance_of(resource_type).to receive(:get_associated_profiles).and_return('Test')
      expect(provider.get_associated_profiles).to be
    end

    it 'should raise a warning when its not able to get the associated profiles' do
      resource['data']['uri'] = '/rest/fake'
      test = resource_type.new(@client, resource['data'])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
      allow_any_instance_of(resource_type).to receive(:get_associated_profiles).and_return('[]')
      expect(provider.get_associated_profiles).to be
    end

    it 'should be able to reset default bandwidth' do
      resource['data']['uri'] = '/rest/fake'
      resource['data']['connectionTemplateUri'] = '/rest/fake'
      resource['data']['bandwidth'] = { 'maximumbandwidth' => '1000' }
      unique_ids = { 'uri' => '/rest/fake', 'name' => 'Puppet Network' }
      test = resource_type.new(@client, resource['data'])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      allow(resource_type).to receive(:find_by).with(anything, unique_ids).and_return([test])
      allow(OneviewSDK::ConnectionTemplate).to receive(:get_default).with(anything).and_return(test)
      allow(OneviewSDK::ConnectionTemplate).to receive(:find_by)
        .with(anything, uri: resource['data']['connectionTemplateUri']).and_return([test])
      provider.exists?
      expect(provider.reset_default_bandwidth).to be
    end
  end
end
