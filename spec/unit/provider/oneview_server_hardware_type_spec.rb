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

provider_class = Puppet::Type.type(:oneview_server_hardware_type).provider(:ruby)

describe provider_class, unit: true do
  include_context 'shared context'

  @resourcetype = OneviewSDK::ServerHardwareType
  let(:resource) do
    Puppet::Type.type(:oneview_server_hardware_type).new(
      name: 'server_hardware_type',
      ensure: 'present',
      data:
          {
            'name' => 'BL460c Gen8 1'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters before server creation' do
    before(:each) do
      test = OneviewSDK::ServerHardwareType.new(@client, resource['data'])
      allow(OneviewSDK::ServerHardwareType).to receive(:find_by).with(anything, resource['data']).and_return([test])
      allow(OneviewSDK::ServerHardwareType).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      allow(OneviewSDK::ServerHardwareType).to receive(:get_all).with(anything).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_server_hardware_type).provider(:ruby)
    end

    it 'should raise error when server is not found' do
      allow(OneviewSDK::ServerHardwareType).to receive(:find_by).with(anything, resource['data']).and_return([])
      expect { provider.found }.to raise_error(/No ServerHardwareType with the specified data were found on the Oneview Appliance/)
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should be able to update the resource name, and change it back' do
      expect(provider.create).to be
    end

    it 'should delete the server hardware' do
      resource['data']['uri'] = '/rest/server-hardware/fake'
      test = OneviewSDK::ServerHardwareType.new(@client, resource['data'])
      allow(OneviewSDK::ServerHardwareType).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.destroy).to be
    end
  end
end
