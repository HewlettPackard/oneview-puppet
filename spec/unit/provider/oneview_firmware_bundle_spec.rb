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

provider_class = Puppet::Type.type(:oneview_firmware_bundle).provider(:oneview_firmware_bundle)

describe provider_class, unit: true do
  include_context 'shared context'

  @resourcetype = OneviewSDK::FirmwareBundle
  let(:resource) do
    Puppet::Type.type(:oneview_firmware_bundle).new(
      name: 'firmware_bundle',
      ensure: 'present',
      data:
          {
            'firmware_bundle_path' => './spec/support/test_firmware_bundle.spp'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters' do
    before(:each) do
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return('test')
      provider.exists?
    end

    it 'should be an instance of the provider oneview_firmware_bundle' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_firmware_bundle).provider(:oneview_firmware_bundle)
    end

    it 'should raise error when firmware bundle is not found' do
      expect { provider.found }.to raise_error(/"Found" is not a valid ensurable for firmware bundle./)
    end

    it 'should raise an error since the destroy operation is not supported' do
      expect { provider.destroy }.to raise_error(/"Absent" is not a valid ensurable for firmware bundle./)
    end

    it 'should create/add the firmware bundle' do
      allow(OneviewSDK::FirmwareBundle).to receive(:add).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.create).to be
    end
  end
end
