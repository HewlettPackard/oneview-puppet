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

provider_class = Puppet::Type.type(:oneview_logical_enclosure).provider(:c7000)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:LogicalEnclosure, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_logical_enclosure).new(
      name: 'fc',
      ensure: 'present',
      data:
          {
            'name'                      =>  'one_enclosure_le',
            'enclosureUris'             =>  '/rest/enclosures/09SGH100X6J1',
            'enclosureGroupUri'         =>  '/rest/enclosure-groups/110e4326-e42f-457a-baca-50e16c590f49',
            'firmwareBaselineUri'       =>  'null',
            'forceInstallFirmware'      =>  'false'
          },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  context 'given the Creation parameters' do
    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_enclosure).provider(:c7000)
    end

    it 'if nothing is found should return false' do
      allow(resource_type).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should return true when resource exists' do
      expect(provider.exists?).to eq(true)
    end

    it 'runs through the create method' do
      allow(resource_type).to receive(:find_by).and_return([])
      allow_any_instance_of(resource_type).to receive(:create).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'deletes the resource' do
      expect_any_instance_of(resource_type).to receive(:delete).and_return([])
      provider.exists?
      expect(provider.destroy).to be
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'finds the resource' do
      expect(provider.found).to be
    end

    it '#gets the script' do
      allow_any_instance_of(resource_type).to receive(:get_script).and_return('')
      expect(provider.get_script).to be
    end

    it '#sets the script on the logical enclosure' do
      resource['data']['script'] = 'Random text script'
      allow_any_instance_of(resource_type).to receive(:set_script).and_return('')
      expect(provider.set_script).to be
    end

    it '#updates the logical enclosure from group -- ~refreshes it' do
      allow_any_instance_of(resource_type).to receive(:update_from_group).and_return(true)
      expect(provider.updated_from_group).to be
    end

    it '#generates a support dump for the logical enclosure' do
      resource['data']['dump'] = 'Random text for dump'
      allow_any_instance_of(resource_type).to receive(:support_dump).and_return(true)
      expect(provider.generate_support_dump).to be
    end
  end
end
