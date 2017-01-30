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

provider_class = Puppet::Type.type(:oneview_volume_template).provider(:synergy)

api_version = login[:api_version] || 200
resource_name = 'VolumeTemplate'
resourcetype = Object.const_get("OneviewSDK::API#{api_version}::Synergy::#{resource_name}") unless api_version < 300

describe provider_class, unit: true, if: login[:api_version] >= 300 do
  include_context 'shared context'

  @resourcetype = resourcetype
  let(:resource) do
    Puppet::Type.type(:oneview_volume_template).new(
      name: 'vt',
      ensure: 'present',
      data:
          {
            'name'         => 'ONEVIEW_PUPPET_TEST',
            'description'  => 'Volume Template',
            'type'         => 'StorageVolumeTemplateV3',
            'stateReason'  => 'None',
            'provisioning' => {
              'shareable'      => true,
              'provisionType'  => 'Thin',
              'capacity'       => '235834383322',
              'storagePoolUri' => '/rest/fake'
            }
          },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resourcetype.new(@client, resource['data']) }

  context 'given the Creation parameters' do
    before(:each) do
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider oneview_volume_template' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_volume_template).provider(:synergy)
    end

    it 'if nothing is found should return false' do
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'runs through the create method' do
      allow(resourcetype).to receive(:find_by).and_return([])
      allow_any_instance_of(resourcetype).to receive(:create).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'should be able to find the connectable volume templates' do
      allow_any_instance_of(resourcetype).to receive(:get_connectable_volume_templates).and_return(true)
      expect(provider.get_connectable_volume_templates).to be
    end
  end
end
