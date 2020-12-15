################################################################################
# (C) Copyright 2016-2020 Hewlett Packard Enterprise Development LP
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

provider_class = Puppet::Type.type(:oneview_volume_template).provider(:c7000)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:VolumeTemplate, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context'

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
      provider: 'c7000'
    )
  end

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
      provider: 'c7000'
    )
  end

  let(:resource_create) do
    Puppet::Type.type(:oneview_volume_template).new(
      name: 'vt',
      ensure: 'present',
      data:
          {
            'name'         => 'ONEVIEW_PUPPET_TEST',
            'description'  => 'Volume Template',
            'type'         => 'StorageVolumeTemplateV3',
            'stateReason'  => 'None',
            'rootTemplateUri' => '',
            'initialScopeUris' => '',
            'provisioning' => {
              'shareable'      => true,
              'provisionType'  => 'Thin',
              'capacity'       => '235834383322',
              'storagePoolUri' => '/rest/fake'
            }
          },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  let(:test_uri) { resource_type.new(@client, resource_create['data']) }

  context 'given the Creation parameters' do
    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
      provider.set_template_uri
      provider.set_scope_uri
      provider.set_initial_scope
      provider.set_storage_pool
    end

    it 'should be an instance of the provider oneview_volume_template' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_volume_template).provider(:c7000)
    end

    it 'should be able to find the resource' do
      expect(provider.found).to be
    end

    it 'runs through the create method' do
      resource_create['data']['rootTemplateUri'] = '/rest/fake'
      resource_create['data']['initialScopeUris'] = '/rest/fake'
      allow_any_instance_of(resource_type).to receive(:create).and_return(test)
      allow_any_instance_of(resource_type).to receive(:set_template_uri).and_return(test_uri)
      allow_any_instance_of(resource_type).to receive(:set_scope_uri).and_return(test_uri)
      provider.exists?
      expect(provider.create).to be
      allow(resource_type).to receive(:get_all).and_return([])
    end

    it 'should be able to find the connectable volume templates' do
      allow_any_instance_of(resource_type).to receive(:get_connectable_volume_templates).and_return(true)
      expect(provider.get_connectable_volume_templates).to be
    end

    it 'should be able to get reachable volume templates' do
      allow(resource_type).to receive(:get_reachable_volume_templates).and_return('True')
      expect(provider.get_reachable_volume_templates).to be
    end

    it 'should be able to get compatible systems' do
      allow_any_instance_of(resource_type).to receive(:get_compatible_systems).and_return(true)
      expect(provider.get_compatible_systems).to be
    end
  end
end
