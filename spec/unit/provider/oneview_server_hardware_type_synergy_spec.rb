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

provider_class = Puppet::Type.type(:oneview_server_hardware_type).provider(:synergy)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:ServerHardwareType, api_version, :Synergy)

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_server_hardware_type).new(
      name: 'server_hardware_type',
      ensure: 'present',
      data:
          {
            'name' => 'BL460c Gen8 1'
          },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  context 'given the minimum parameters before server creation' do
    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      allow(resource_type).to receive(:get_all).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider synergy' do
      provider.exists?
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_server_hardware_type).provider(:synergy)
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should raise error when server is not found' do
      allow(resource_type).to receive(:find_by).and_return([])
      provider.exists?
      expect { provider.found }.to raise_error(/No ServerHardwareType with the specified data were found on the Oneview Appliance/)
    end

    it 'should be able to update the resource name, and change it back' do
      allow_any_instance_of(resource_type).to receive(:update).and_return(test)
      provider.exists?
      expect(provider.create).to be
    end

    it 'should delete the server hardware' do
      expect_any_instance_of(resource_type).to receive(:remove).and_return(true)
      provider.exists?
      expect(provider.destroy).to be
    end
  end
end
