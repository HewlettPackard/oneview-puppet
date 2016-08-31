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

provider_class = Puppet::Type.type(:oneview_firmware_bundle).provider(:oneview_firmware_bundle)
firmware_bundle_path = login[:firmware_bundle_path] || './spec/support/cp022594.exe'

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_firmware_bundle).new(
      name: 'firmware_bundle',
      ensure: 'present',
      data:
          {
            'firmware_bundle_path' => firmware_bundle_path
          }
    )
  end

  before(:each) do
    provider.exists?
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters' do
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
      expect(provider.create).to be
    end
  end
end
