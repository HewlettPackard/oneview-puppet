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

provider_class = Puppet::Type.type(:oneview_sas_logical_interconnect).provider(:synergy)
api_version = login[:api_version] || 200
resourcetype = OneviewSDK.resource_named(:SASLogicalInterconnect, api_version, 'Synergy')

describe provider_class, unit: true, if: login[:api_version] >= 300 do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_sas_logical_interconnect).new(
      name: 'Test Logical Interconnect',
      ensure: 'present',
      data:
      {
        'name'     => 'Puppet_Test_Enclosure-SAS LIG-1',
        'firmware' =>
        {
          'command' => 'Stage',
          # 'sspUri'  => 'fake_firmware.iso',
          'sspUri'  => '/rest/firmware-drivers/fake_firmware',
          'force'   => false
        },
        'oldSerialNumber' => 'SN123100',
        'newSerialNumber' => 'SN123102'
      },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resourcetype.new(@client, resource['data']) }

  context 'given the min parameters' do
    before(:each) do
      allow(resourcetype).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider synergy' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_sas_logical_interconnect).provider(:synergy)
    end

    it 'should be able to run self.instances' do
      expect(instance).to be
    end

    it 'should raise an error for unsupported ensure methods' do
      expect { provider.create }.to raise_error(/This resource relies on others to be created./)
      expect { provider.destroy }.to raise_error(/This resource relies on others to be destroyed./)
    end

    it 'should find the resource' do
      expect(provider.found).to be
    end

    it 'should be able to get the firmware' do
      allow_any_instance_of(resourcetype).to receive(:get_firmware).and_return('Test')
      expect(provider.get_firmware).to be
    end

    it 'should be able to set the compliance' do
      allow_any_instance_of(resourcetype).to receive(:compliance).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.set_compliance).to be
    end

    it 'should be able to set the configuration' do
      allow_any_instance_of(resourcetype).to receive(:configuration).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.set_configuration).to be
    end

    it 'should be able to set the firmware' do
      allow(OneviewSDK::FirmwareDriver).to receive(:find_by).and_return(
        [OneviewSDK::FirmwareDriver.new(@client, name: 'test')]
      )
      allow_any_instance_of(resourcetype).to receive(:firmware_update).and_return(true)
      expect(provider.set_firmware).to be
    end

    it 'should be able to update the drive serial numbers after replacement' do
      allow_any_instance_of(resourcetype).to receive(:replace_drive_enclosure).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.replace_drive_enclosure).to be
    end
  end
end
