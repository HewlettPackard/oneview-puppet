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

provider_class = Puppet::Type.type(:oneview_logical_switch).provider(:ruby)

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:oneview_logical_switch).new(
      name: 'LS',
      ensure: 'present',
      data:
          {
            'name' => 'LS',
            'logicalSwitchGroupUri' => '/rest/logical-switch-groups/32a67e21-c5c6-4855-aed5-443720b2c921',
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
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  before(:each) do
    provider.exists?
  end

  context 'given the minimum parameters' do
    it 'should be an instance of the provider Ruby' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_switch).provider(:oneview_logical_switch)
    end

    it 'exists? should not find logical switch' do
      expect(provider.exists?).not_to be
    end

    it 'should be able to create a new logical switch' do
      expect(provider.create).to be
    end

    it 'should be able to find the logical switch' do
      expect(provider.found).to be
    end

    it 'should be able to destroy the logical switch' do
      expect(provider.destroy).to be
    end
  end
end
