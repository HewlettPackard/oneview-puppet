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
require File.expand_path(File.join(File.dirname(__FILE__), '../../../lib/puppet/provider/', 'login'))

provider_class = Puppet::Type.type(:oneview_server_hardware_type).provider(:oneview_server_hardware_type)
server_hardware_type = login[:server_hardware_type] || 'BL460c Gen8 1'

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_server_hardware_type).new(
      name: 'server_hardware_type',
      ensure: 'present',
      data:
          {
            'name' => server_hardware_type
          }
    )
  end

  before(:each) do
    provider.exists?
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters before server creation' do
    it 'should be an instance of the provider oneview_server_hardware_type' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_server_hardware_type).provider(:oneview_server_hardware_type)
    end

    it 'should raise error when server is not found' do
      resource['data']['name'] = 'Test'
      expect { provider.found }.to raise_error(/No ServerHardwareType with the specified data were found on the Oneview Appliance/)
    end

    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should be able to update the resource name, and change it back' do
      resource['data']['new_name'] = 'Puppet Test'
      expect(provider.create).to be
      resource['data']['name'] = 'Puppet Test'
      resource['data']['new_name'] = 'BL460c Gen8 1'
      expect(provider.create).to be
    end
    # NOTE: This requires the server hardware type to not be in use to work, so not the most reliable integration Test
    # Leaving commented for now, may revisit in the future
    # it 'should delete the server hardware' do
    #   expect(provider.destroy).to be
    # end
  end
end
