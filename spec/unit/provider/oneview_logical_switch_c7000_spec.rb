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
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_logical_switch).provider(:c7000)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:LogicalSwitch, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_logical_switch).new(
      name: 'LS',
      ensure: 'present',
      data:
          {
            'name' => 'LS',
            'logicalSwitchGroupUri' => '/rest/',
            'switches' =>
            [
              {
                'ip' => '172.18.20.1',
                'ssh_username' => 'dcs',
                'ssh_password' => 'dcs',
                'snmp_port' => '161',
                'community_string' => 'public'
              },
              {
                'ip' => '172.18.20.1',
                'ssh_username' => 'dcs',
                'ssh_password' => 'dcs',
                'snmp_port' => '161',
                'community_string' => 'public'
              }
            ]
          },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, name: resource['data']['name']) }

  context 'given the min parameters' do
    before(:each) do
      allow(resource_type).to receive(:find_by).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_switch).provider(:c7000)
    end

    it 'should be able to find the resource' do
      expect(provider.found).to be
    end

    it 'should refresh the logical switch' do
      allow_any_instance_of(resource_type).to receive(:refresh).and_return(true)
      expect(provider.refresh).to be
    end

    it 'should be able to create the resource' do
      allow(resource_type).to receive(:find_by).and_return([])
      allow_any_instance_of(resource_type).to receive(:create).and_return(resource_type.new(@client, resource['data']))
      expect(provider.create).to be
    end

    it 'should show method as deprecated' do
      expect { provider.update_credentials }.to raise_error(/This method was deprecated./)
    end
  end
end
