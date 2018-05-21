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

describe provider_class, integration: true do
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

  before(:each) do
    provider.exists?
  end

  it 'should be an instance of the provider synergy' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_sas_logical_interconnect).provider(:synergy)
  end

  it '#self.instances should be able to run normally' do
    expect(instance).to be
  end

  it 'should find the logical interconnect' do
    expect(provider.found).to be
  end

  it 'should get the firmware from the logical interconnect' do
    expect(provider.get_firmware).to be
  end

  it 'should get the logical interconnect compliant' do
    expect(provider.set_compliance).to be
  end

  it 'should set the firmware configuration' do
    expect(provider.set_firmware).to be
  end

  it 'should set the LI configuration' do
    expect(provider.set_configuration).to be
  end

  it 'should be able to update the serial number of drives in the enclosure after replacement' do
    expect(provider.replace_drive_enclosure).to be
  end

  it 'should raise an error for unsupported operations' do
    expect { provider.create }.to raise_error(/This resource relies on others to be created./)
    expect { provider.destroy }.to raise_error(/This resource relies on others to be destroyed./)
  end
end
