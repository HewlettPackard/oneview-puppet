################################################################################
# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
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
require_relative '../../../lib/puppet/provider/uri_parsing.rb'

describe 'uri_parsing', unit: true do
  let(:names_list) { %w(name1 name2) }

  let(:name) { 'name1' }

  let(:fake_uri) { '/rest/fakeuri' }

  describe 'given Image Streamer resources' do
    include_context 'shared context Image Streamer'

    let(:resource_variant) { 'does not apply' }

    let(:golden_image_name) { 'Golden Image Name' }

    let(:golden_image_uri) { '/rest/uri/golden-images/fake' }

    let(:golden_image) do
      OneviewSDK::ImageStreamer::API300::GoldenImage.new(@client, 'name' => golden_image_name, 'uri' => golden_image_uri)
    end

    before(:each) do
      golden_image_type = OneviewSDK::ImageStreamer::API300::GoldenImage
      allow(golden_image_type).to receive(:find_by).with(anything, name: golden_image_name).and_return([golden_image])
    end

    it 'should replace resource name by uri when key contains Uri' do
      data = { 'goldenImageUri' => golden_image_name }
      expect(uri_validation(data)).to eq 'goldenImageUri' => golden_image_uri
    end

    it 'should replace resource name by uri when key contains URI' do
      data = { 'goldenImageURI' => golden_image_name }
      expect(uri_validation(data)).to eq 'goldenImageURI' => golden_image_uri
    end

    it 'should replace resource name by uri using recursion' do
      data = { 'goldenImageUri' => golden_image_name,
               'value'          => { 'goldenImageUri' => golden_image_name,
                                     'list'           => ['goldenImageUri' => golden_image_name] } }

      expected_result = { 'goldenImageUri' => golden_image_uri,
                          'value'          => { 'goldenImageUri' => golden_image_uri,
                                                'list'           => ['goldenImageUri' => golden_image_uri] } }

      expect(uri_validation(data)).to eq expected_result
    end

    it 'should replace resource name by uri when key is resourceUri' do
      data = { 'resourceUri' => "#{golden_image_name},GoldenImage" }

      expected_result = { 'resourceUri' => golden_image_uri }
      expect(uri_validation(data)).to eq expected_result
    end

    it 'should get the classname to find the resource' do
      expect(get_class('goldenImageUri')).to eq OneviewSDK::ImageStreamer::API300::GoldenImage
    end

    it 'should do nothing when key contains uris' do
      data = { 'golden_image_uris' => [golden_image_name] }
      expect(uri_validation(data)).to eq 'golden_image_uris' => [golden_image_name]
    end

    it 'should raise error when class is not found' do
      expect { get_class('invalidUri') }.to raise_error(NameError)
    end
  end

  describe 'given OneView resources and API Version 300' do
    include_context 'shared context'

    let(:resource_variant) { 'C7000' }

    let(:enclosure_name) { 'Enclosure Name' }

    let(:enclosure_uri) { '/rest/uri/enclosures/fake' }

    let(:enclosure) do
      OneviewSDK::API300::C7000::Enclosure.new(@client, 'name' => enclosure_name, 'uri' => enclosure_uri)
    end

    before(:each) do
      allow(OneviewSDK::API300::C7000::Enclosure).to receive(:find_by).with(anything, name: 'Enclosure Name').and_return([enclosure])
    end

    it 'should replace resource name by uri when key contains Uri' do
      data = { 'enclosureUri' => enclosure_name }
      expect(uri_validation(data)).to eq 'enclosureUri' => enclosure_uri
    end

    it 'should replace resource name by uri when key contains URI' do
      data = { 'enclosureUri' => enclosure_name }
      expect(uri_validation(data)).to eq 'enclosureUri' => enclosure_uri
    end

    it 'should replace resource name by uri using recursion' do
      data = { 'enclosureUri' => enclosure_name,
               'value'          => { 'enclosureUri' => enclosure_name,
                                     'list'         => ['enclosureUri' => enclosure_name] } }

      expected_result = { 'enclosureUri' => enclosure_uri,
                          'value'        => { 'enclosureUri' => enclosure_uri,
                                              'list'         => ['enclosureUri' => enclosure_uri] } }

      expect(uri_validation(data)).to eq expected_result
    end

    it 'should replace resource name by uri when key is resourceUri' do
      data = { 'resourceUri' => "#{enclosure_name},Enclosure" }
      expect(uri_validation(data)).to eq 'resourceUri' => enclosure_uri
    end

    it 'should get the classname to find the resource' do
      expect(get_class('enclosureUri')).to eq OneviewSDK::API300::C7000::Enclosure
    end

    it 'should do nothing when key contains uris' do
      data = { 'enclosure_uris' => [enclosure_name] }
      expect(uri_validation(data)).to eq 'enclosure_uris' => [enclosure_name]
    end

    it 'should raise error when class is not found' do
      expect { get_class('invalidUri') }.to raise_error(NameError)
    end
  end

  describe 'given OneView resources and API Version 200' do
    include_context 'shared context OneView API 200'

    let(:resource_variant) { 'C7000' }

    let(:enclosure_name) { 'Enclosure Name' }

    let(:enclosure_uri) { '/rest/uri/enclosures/fake' }

    let(:enclosure) do
      OneviewSDK::API200::Enclosure.new(@client, 'name' => enclosure_name, 'uri' => enclosure_uri)
    end

    before(:each) do
      allow(OneviewSDK::API200::Enclosure).to receive(:find_by).with(anything, name: 'Enclosure Name').and_return([enclosure])
    end

    it 'should replace resource name by uri when key contains Uri' do
      data = { 'enclosureUri' => enclosure_uri }
      expect(uri_validation(data)).to eq 'enclosureUri' => enclosure_uri
    end

    it 'should replace resource name by uri when key contains URI' do
      data = { 'enclosureURI' => enclosure_name }
      expect(uri_validation(data)).to eq 'enclosureURI' => enclosure_uri
    end

    it 'should replace resource name by uri using recursion' do
      data = { 'enclosureUri' => enclosure_name,
               'value'          => { 'enclosureUri' => enclosure_name,
                                     'list'         => ['enclosureUri' => enclosure_name] } }

      expected_result = { 'enclosureUri' => enclosure_uri,
                          'value'        => { 'enclosureUri' => enclosure_uri,
                                              'list'         => ['enclosureUri' => enclosure_uri] } }

      expect(uri_validation(data)).to eq expected_result
    end

    it 'should replace resource name by uri when key is resourceUri' do
      data = { 'resourceUri' => "#{enclosure_name},Enclosure" }
      expect(uri_validation(data)).to eq 'resourceUri' => enclosure_uri
    end

    it 'should get the classname to find the resource' do
      expect(get_class('enclosureUri')).to eq OneviewSDK::API200::Enclosure
    end

    it 'should do nothing when key contains uris' do
      data = { 'enclosure_uris' => [enclosure_name] }
      expect(uri_validation(data)).to eq 'enclosure_uris' => [enclosure_name]
    end

    it 'should raise error when class is not found' do
      expect { get_class('invalidUri') }.to raise_error(NameError)
    end
  end

  describe 'given the value is already an URI or it is null' do
    include_context 'shared context'

    it 'should do nothing when value is nil' do
      data = { 'enclosureUri' => nil }
      expect(uri_validation(data)).to eq 'enclosureUri' => nil
    end

    it 'should do nothing when value is a string nil' do
      data = { 'enclosureUri' => 'nil' }
      expect(uri_validation(data)).to eq 'enclosureUri' => 'nil'
    end

    it 'should do nothing when value is a string null' do
      data = { 'enclosureUri' => 'null' }
      expect(uri_validation(data)).to eq 'enclosureUri' => 'null'
    end

    it 'should do nothing when value is already an URI' do
      data = { 'enclosureUri' => fake_uri }
      expect(uri_validation(data)).to eq 'enclosureUri' => fake_uri
    end
  end

  describe 'given the OneView special resources managed by the provider' do
    include_context 'shared context'

    it 'should do nothing when key is networkUris' do
      data = { 'networkUris' => names_list }
      expect(uri_validation(data)).to eq 'networkUris' => names_list
    end

    # Remove this test case once the array handling is done
    it 'should do nothing when key is enclosureUris' do
      data = { 'enclosureUris' => names_list }
      expect(uri_validation(data)).to eq 'enclosureUris' => names_list
    end

    it 'should do nothing when key is networkUri' do
      data = { 'networkUri' => name }
      expect(uri_validation(data)).to eq 'networkUri' => name
    end

    it 'should do nothing when key is hotfixUris' do
      data = { 'hotfixUris' => names_list }
      expect(uri_validation(data)).to eq 'hotfixUris' => names_list
    end

    it 'should do nothing when key is fcNetworkUris' do
      data = { 'fcNetworkUris' => names_list }
      expect(uri_validation(data)).to eq 'fcNetworkUris' => names_list
    end

    it 'should do nothing when key is fcoeNetworkUris' do
      data = { 'fcoeNetworkUris' => names_list }
      expect(uri_validation(data)).to eq 'fcoeNetworkUris' => names_list
    end

    it 'should do nothing when key is networkUri' do
      data = { 'connectionUri' => name }
      expect(uri_validation(data)).to eq 'connectionUri' => name
    end

    it 'should do nothing when key is providerUri' do
      data = { 'providerUri' => name }
      expect(uri_validation(data)).to eq 'providerUri' => name
    end

    it 'should do nothing when key is permittedInterconnectTypeUri' do
      data = { 'permittedInterconnectTypeUri' => name }
      expect(uri_validation(data)).to eq 'permittedInterconnectTypeUri' => name
    end

    it 'should do nothing when key is permittedSwitchTypeUri' do
      data = { 'permittedSwitchTypeUri' => name }
      expect(uri_validation(data)).to eq 'permittedSwitchTypeUri' => name
    end

    it 'should do nothing when key is internalNetworkUris' do
      data = { 'internalNetworkUris' =>  names_list }
      expect(uri_validation(data)).to eq 'internalNetworkUris' => names_list
    end
  end

  describe 'given the OneView special resources managed by uri_parsing' do
    include_context 'shared context'

    let(:resource_variant) { 'C7000' }

    before(:each) do
      driver = OneviewSDK::API300::C7000::FirmwareDriver.new(@client, 'name' => name, 'uri' => '/rest/firmware-drivers/fake-id')
      allow(OneviewSDK::API300::C7000::FirmwareDriver).to receive(:find_by).with(anything, name: name).and_return([driver])

      storage_pool = OneviewSDK::API300::C7000::StoragePool.new(@client, 'name' => name, 'uri' => '/rest/storage-pools/fake-id')
      allow(OneviewSDK::API300::C7000::StoragePool).to receive(:find_by).with(anything, name: name).and_return([storage_pool])
    end

    it 'should replace FirmwareDriver name by uri when key is firmwareBaselineUri' do
      data = { 'firmwareBaselineUri' => name }
      expect(uri_validation(data)).to eq 'firmwareBaselineUri' => '/rest/firmware-drivers/fake-id'
    end

    it 'should replace FirmwareDriver name by uri when key is sspUri' do
      data = { 'sspUri' => name }
      expect(uri_validation(data)).to eq 'sspUri' => '/rest/firmware-drivers/fake-id'
    end

    it 'should replace FirmwareDriver name by uri when key is baselineUri' do
      data = { 'baselineUri' => name }
      expect(uri_validation(data)).to eq 'baselineUri' => '/rest/firmware-drivers/fake-id'
    end

    it 'should replace ManagedSAN name by uri when key is actualNetworkSanUri' do
      san = OneviewSDK::API300::C7000::ManagedSAN.new(@client, 'name' => name, 'uri' => '/rest/fc-sans/managed-sans/fake-id')
      allow(OneviewSDK::API300::C7000::ManagedSAN).to receive(:find_by).with(anything, name: name).and_return([san])

      data = { 'actualNetworkSanUri' => name }
      expect(uri_validation(data)).to eq 'actualNetworkSanUri' => '/rest/fc-sans/managed-sans/fake-id'
    end

    it 'should replace LogicalInterconnect name by uri when key is dependentResourceUri' do
      uri = '/rest/logical-interconnects/fake-id'
      log_interc = OneviewSDK::API300::C7000::LogicalInterconnect.new(@client, 'name' => name, 'uri' => uri)
      allow(OneviewSDK::API300::C7000::LogicalInterconnect).to receive(:find_by).with(anything, name: name).and_return([log_interc])

      data = { 'dependentResourceUri' => name }
      expect(uri_validation(data)).to eq 'dependentResourceUri' => '/rest/logical-interconnects/fake-id'
    end

    it 'should replace StoragePool name by uri when key is snapshotPoolUri' do
      data = { 'snapshotPoolUri' => name }
      expect(uri_validation(data)).to eq 'snapshotPoolUri' => '/rest/storage-pools/fake-id'
    end

    it 'should replace StoragePool name by uri when key is volumeStoragePoolUri' do
      data = { 'volumeStoragePoolUri' => name }
      expect(uri_validation(data)).to eq 'volumeStoragePoolUri' => '/rest/storage-pools/fake-id'
    end

    it 'should replace StorageSystem name by uri when key is volumeStorageSystemUri' do
      storage_system = OneviewSDK::API300::C7000::StorageSystem.new(@client, 'name' => name, 'uri' => '/rest/storage-systems/fake-id')
      allow(OneviewSDK::API300::C7000::StorageSystem).to receive(:find_by).with(anything, name: name).and_return([storage_system])

      data = { 'volumeStorageSystemUri' => name }
      expect(uri_validation(data)).to eq 'volumeStorageSystemUri' => '/rest/storage-systems/fake-id'
    end

    it 'should replace UplinkSet name by uri when key is associatedUplinkSetUri' do
      uplink_set = OneviewSDK::API300::C7000::UplinkSet.new(@client, 'name' => name, 'uri' => '/rest/uplink-sets/fake-id')
      allow(OneviewSDK::API300::C7000::UplinkSet).to receive(:find_by).with(anything, name: name).and_return([uplink_set])

      data = { 'associatedUplinkSetUri' => name }
      expect(uri_validation(data)).to eq 'associatedUplinkSetUri' => '/rest/uplink-sets/fake-id'
    end

    it 'should replace Task name by uri when key is associatedTaskUri' do
      associated_task = OneviewSDK::API300::C7000::Task.new(@client, 'name' => name, 'uri' => '/rest/tasks/fake-id')
      allow(OneviewSDK::API300::C7000::Task).to receive(:find_by).with(anything, name: name).and_return([associated_task])

      data = { 'associatedTaskUri' => name }
      expect(uri_validation(data)).to eq 'associatedTaskUri' => '/rest/tasks/fake-id'
    end

    it 'should replace EthernetNetwork name by uri when key is nativeNetworkUri' do
      eth_network = OneviewSDK::API300::C7000::EthernetNetwork.new(@client, 'name' => name, 'uri' => '/rest/ethernet-networks/fake-id')
      allow(OneviewSDK::API300::C7000::EthernetNetwork).to receive(:find_by).with(anything, name: name).and_return([eth_network])

      data = { 'nativeNetworkUri' => name }
      expect(uri_validation(data)).to eq 'nativeNetworkUri' => '/rest/ethernet-networks/fake-id'
    end

    # Use this test case when enclosureUris is handled as Array.
    # it 'should replace Enclosure name by uri when key is enclosureUris' do
    #  enclosure = OneviewSDK::API300::C7000::Enclosure.new(@client, 'name' => name, 'uri' => '/rest/enclosures/fake-id')
    #  allow(OneviewSDK::API300::C7000::Enclosure).to receive(:find_by).with(anything, name: name).and_return([enclosure])

    #  data = { 'enclosureUris' => name }
    #  expect(uri_validation(data)).to eq 'enclosureUris' => '/rest/enclosures/fake-id'
    # end
  end

  describe 'given the OneView Synergy special resources managed by uri_parsing' do
    include_context 'shared context'

    let(:resource_variant) { 'Synergy' }

    it 'should replace OS Deployment Plan name by uri when key is osDeploymentPlanUri' do
      uri = '/rest/os-deployment-plans/fake-id'
      deployment_plan = OneviewSDK::API300::Synergy::OSDeploymentPlan.new(@client, 'name' => name, 'uri' => uri)
      allow(OneviewSDK::API300::Synergy::OSDeploymentPlan).to receive(:find_by).with(anything, name: name).and_return([deployment_plan])

      data = { 'osDeploymentPlanUri' => name }
      expect(uri_validation(data)).to eq 'osDeploymentPlanUri' => uri
    end
  end

  describe 'given the ImageStreamer special resources managed by uri_parsing' do
    include_context 'shared context Image Streamer'

    it 'should replace BuildPlan name by uri when key is oeBuildPlanURI' do
      build_plan = OneviewSDK::ImageStreamer::API300::BuildPlan.new(@client, 'name' => name, 'uri' => '/rest/build-plans/fake-id')
      allow(OneviewSDK::ImageStreamer::API300::BuildPlan).to receive(:find_by).with(anything, name: name).and_return([build_plan])

      data = { 'oeBuildPlanURI' => name }
      expect(uri_validation(data)).to eq 'oeBuildPlanURI' => '/rest/build-plans/fake-id'
    end

    it 'should replace OSVolume name by uri when key is osVolumeURI' do
      build_plan = OneviewSDK::ImageStreamer::API300::OSVolume.new(@client, 'name' => name, 'uri' => '/rest/os-volumes/fake-id')
      allow(OneviewSDK::ImageStreamer::API300::OSVolume).to receive(:find_by).with(anything, name: name).and_return([build_plan])

      data = { 'osVolumeURI' => name }
      expect(uri_validation(data)).to eq 'osVolumeURI' => '/rest/os-volumes/fake-id'
    end
  end
end
