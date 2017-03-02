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

provider_class = Puppet::Type.type(:oneview_firmware_driver).provider(:c7000)
api_version = login[:api_version] || 200
resourcetype = OneviewSDK.resource_named(:FirmwareDriver, api_version, 'C7000')

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_firmware_driver).new(
      name: 'firmware_driver',
      ensure: 'found',
      data:
          {
            'name' => 'FirmwareDriver1_Example'
          },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resourcetype.new(@client, resource['data']) }

  context 'given the minimum parameters' do
    it 'should be an instance of the provider oneview_firmware_driver' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_firmware_driver).provider(:c7000)
    end

    it 'should raise error when Firmware Driver is not found' do
      allow(resourcetype).to receive(:find_by).and_return([])
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
              'baselineUri'        => '/rest/fake',
              'hotfixUris'         => ['/rest/fake']
            },
        provider: 'c7000'
      )
    end

    before(:each) do
      allow(resourcetype).to receive(:find_by).with(anything, 'name' => resource['data']['customBaselineName'])
        .and_return([test])
      allow(resourcetype).to receive(:find_by).with(anything, name: resource['data']['baselineUri']).and_return([test])
      allow(resourcetype).to receive(:find_by).with(anything, name: resource['data']['hotfixUris'][0]).and_return([test])
      allow(resourcetype).to receive(:find_by).with(anything, name: resource['data']).and_return([])
      allow(resourcetype).to receive(:get_all).with(anything).and_return([test])
      provider.exists?
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'runs through the create method' do
      allow(resourcetype).to receive(:find_by).and_return([])
      allow_any_instance_of(resourcetype).to receive(:create).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'should delete the Firmware Driver' do
      resource['data']['uri'] = '/rest/firmware-drivers/fake'
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.destroy).to be
    end

    it 'should be able to work specifying a name instead of an uri' do
      resource['data']['baselineUri'] = 'Test'
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, name: resource['data']['baselineUri']).and_return([test])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect(provider.exists?).to be
    end
  end
end
