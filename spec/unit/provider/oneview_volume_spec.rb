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

provider_class = Puppet::Type.type(:oneview_volume).provider(:c7000)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:Volume, api_version, :C7000)
vt_class = OneviewSDK.resource_named(:VolumeTemplate, api_version, :C7000)
sp_class = OneviewSDK.resource_named(:StoragePool, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context'
  context 'given the minimum parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_volume).new(
        name: 'Storage Pool',
        ensure: 'present',
        data:
            {
              'name' => 'Oneview_Puppet_TEST_VOLUME_1',
              'description' => 'Test',
              'provisioningParameters' => {
                'provisionType' => 'Full',
                'shareable' => true,
                'requestedCapacity' => 1024 * 1024 * 1024,
                'storagePoolUri' => '/rest/fake'
              },
              'snapshotPoolUri' => '/rest/fake'
            },
        provider: 'c7000'
      )
    end

    let(:vt) do
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

    let(:sp) do
      Puppet::Type.type(:oneview_storage_pool).new(
        name: 'Storage Pool',
        ensure: 'present',
        data:
           {
             'name' => '172.18.8.11, PDU 1',
             'poolName' => 'CPG-SSD-AO',
             'storageSystemUri' => '/rest/fake'
           },
        provider: 'c7000'
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    let(:test) { resource_type.new(@client, resource['data']) }

    let(:vt_test) { vt_class.new(@client, name: vt['data']) }

    let(:sp_test) { sp_class.new(@client, name: sp['data']) }

    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be able to run through self.instances' do
      allow(resource_type).to receive(:find_by).and_return([test])
      expect(instance).to be
    end

    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_volume).provider(:c7000)
    end

    it 'should able to find the resource' do
      expect(provider.found).to be
    end

    it 'runs through the create method' do
      allow(resource_type).to receive(:find_by).and_return([])
      allow_any_instance_of(resource_type).to receive(:create).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'should return false if volume template does not exist' do
      allow(OneviewSDK::VolumeTemplate).to receive(:find_by).and_return([])
    end

    it 'should return true if volume template exists / is found' do
      allow(vt_class).to receive(:find_by).with(anything, vt['data']).and_return([vt_test])
      expect(provider.exists?).to be
      expect(provider.found).to eq(true)
    end

    it 'should be able to get the snapshots' do
      allow_any_instance_of(resource_type).to receive(:get_snapshots).and_return('Test')
      expect(provider.get_snapshot).to be
    end

    it 'should be able to get a snapshot by name' do
      resource['data']['snapshotParameters'] = { 'name' => 'Snapshot' }
      allow_any_instance_of(resource_type).to receive(:get_snapshot).and_return('Test')
      provider.exists?
      expect(provider.get_snapshot).to be
    end

    it 'should be able to repair' do
      allow_any_instance_of(resource_type).to receive(:repair).and_return('Test')
      expect(provider.repair).to be
    end

    it 'should be able to get the attachable volumes' do
      allow(resource_type).to receive(:get_attachable_volumes).with(anything, nil).and_return('Test')
      expect(provider.get_attachable_volumes).to be
    end

    it 'should be able to get the extra managed volume paths' do
      allow(resource_type).to receive(:get_extra_managed_volume_paths).with(anything).and_return('Test')
      expect(provider.get_extra_managed_volume_paths).to be
    end

    it 'should delete the snapshot' do
      resource['data']['snapshotParameters'] = { 'name' => 'Snapshot' }
      allow_any_instance_of(resource_type).to receive(:delete_snapshot).with(resource['data']['snapshotParameters']['name'])
                                                                       .and_return('Test')
      provider.exists?
      expect(provider.delete_snapshot).to be
    end

    it 'should create the snapshot' do
      resource['data']['snapshotParameters'] = { 'name' => 'Snapshot' }
      allow_any_instance_of(resource_type).to receive(:create_snapshot).with('name' => resource['data']['snapshotParameters']['name'])
                                                                       .and_return('Test')
      provider.exists?
      expect(provider.create_snapshot).to be
    end
  end
end
