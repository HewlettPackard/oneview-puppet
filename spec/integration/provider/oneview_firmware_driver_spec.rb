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
require File.expand_path(File.join(File.dirname(__FILE__), '../../../lib/puppet/provider/', 'login'))

provider_class = Puppet::Type.type(:oneview_firmware_driver).provider(:oneview_firmware_driver)
firmware_baseline_name = login[:firmware_baseline_name] || 'Service Pack for ProLiant'
firmware_hotfix_names = login[:firmware_hotfix_names] || ['Online ROM Flash Component for Windows x64 - HPE ProLiant XL260a Gen9 Server']

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_firmware_driver).new(
      name: 'firmware_driver',
      ensure: 'found',
      data:
          {
            'name' => 'FirmwareDriver1_Example'
          }
    )
  end

  before(:each) do
    provider.exists?
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters' do
    it 'should be an instance of the provider oneview_firmware_driver' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_firmware_driver).provider(:oneview_firmware_driver)
    end

    it 'should raise error when Firmware Driver is not found' do
      expect { provider.found }.to raise_error(/No FirmwareDriver with the specified data were found on the Oneview Appliance/)
    end
  end

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_firmware_driver).new(
        name: 'firmware_driver',
        ensure: 'present',
        data:
            {
              'customBaselineName' => 'FirmwareDriver1_Example',
              'baselineUri'        => firmware_baseline_name,
              'hotfixUris'         => firmware_hotfix_names
            }
      )
    end
    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should create/add the Firmware Driver' do
      expect(provider.create).to be
    end

    it 'should delete the Firmware Driver' do
      expect(provider.destroy).to be
    end
  end
end
