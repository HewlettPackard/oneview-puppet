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

provider_class = Puppet::Type.type(:oneview_enclosure_group).provider(:c7000)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:EnclosureGroup, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context'

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_enclosure_group).new(
        name: 'EnclosureGroup',
        ensure: 'present',
        data:
          {
            'name'                         => 'Enclosure Group',
            'interconnectBayMappingCount'  => '8',
            'stackingMode'                 => 'Enclosure',
            'interconnectBayMappings'      =>
            [
              {
                'interconnectBay' => '1',
                'logicalInterconnectGroupUri' => nil
              },
              {
                'interconnectBay' => '2',
                'logicalInterconnectGroupUri' => nil
              },
              {
                'interconnectBay' => '3',
                'logicalInterconnectGroupUri' => nil
              },
              {
                'interconnectBay' => '4',
                'logicalInterconnectGroupUri' => nil
              },
              {
                'interconnectBay' => '5',
                'logicalInterconnectGroupUri' => nil
              },
              {
                'interconnectBay' => '6',
                'logicalInterconnectGroupUri' => nil
              },
              {
                'interconnectBay' => '7',
                'logicalInterconnectGroupUri' => nil
              },
              {
                'interconnectBay' => '8',
                'logicalInterconnectGroupUri' => nil
              }
            ]
          },
        provider: 'c7000'
      )
    end

    let(:resource_create) do
      Puppet::Type.type(:oneview_enclosure_group).new(
        name: 'EnclosureGroup',
        ensure: 'present',
        data:
          {
            'name'                         => 'Enclosure Group',
            'interconnectBayMappingCount'  => '8',
            'stackingMode'                 => 'Enclosure',
            'interconnectBayMappings'      =>
            [
              {
                'interconnectBay' => '1',
                'logicalInterconnectGroupUri' => ''
              },
              {
                'interconnectBay' => '2',
                'logicalInterconnectGroupUri' => ''
              }
            ]
          },
        provider: 'c7000'
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    let(:test) { resource_type.new(@client, resource['data']) }

    let(:test_uri) { resource_type.new(@client, resource_create['data']) }

    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_enclosure_group).provider(:c7000)
    end

    it 'runs through the create method' do
      resource_create['data']['interconnectBayMappings'][0]['logicalInterconnectGroupUri'] = '/rest/fake'
      resource_create['data']['interconnectBayMappings'][1]['logicalInterconnectGroupUri'] = '/rest/fake'
      allow(resource_type).to receive(:find_by).and_return([])
      expect_any_instance_of(resource_type).to receive(:create).and_return(test)
      expect_any_instance_of(resource_type).to receive(:set_lig_uri).and_return(test_uri)
      expect(provider.create).to be
      allow(resource_type).to receive(:get_all).and_return([])
    end

    it 'deletes the resource' do
      allow(resource_type).to receive(:find_by).and_return([test])
      expect_any_instance_of(resource_type).to receive(:delete).and_return(true)
      expect(provider.destroy).to be
    end

    it 'should be able to get the script' do
      allow_any_instance_of(resource_type).to receive(:get_script).and_return('Test')
      expect(provider.get_script).to be
    end

    it 'should be able to set the script' do
      resource['data']['script'] = 'Sample'
      allow_any_instance_of(resource_type).to receive(:set_script).with('Sample').and_return('Sample')
      provider.exists?
      expect(provider.set_script).to be
    end
  end
end
