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
require_relative '../../../lib/puppet/provider/login'

provider_class = Puppet::Type.type(:oneview_server_hardware).provider(:synergy)
server_hardware_hostname = login[:server_hardware_hostname] || '172.18.6.4'

describe provider_class, integration: true do
  let(:resource) do
    Puppet::Type.type(:oneview_server_hardware).new(
      name: 'server_hardware',
      ensure: 'present',
      data:
          {
            'hostname' => server_hardware_hostname
          },
      provider: 'synergy'
    )
  end

  before(:each) do
    provider.exists?
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given minimum parameters to find the resource' do
    it 'should be an instance of the provider synergy' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_server_hardware).provider(:synergy)
    end

    it 'should raise error when server is not found' do
      expect { provider.found }.to raise_error(/No ServerHardware with the specified data were found on the Oneview Appliance/)
    end
  end

  context 'given enough parameters to find the resource' do
    let(:resource) do
      Puppet::Type.type(:oneview_server_hardware).new(
        name: 'server_hardware',
        ensure: 'present',
        data:
            {
              'name' => '0000A66101, bay 3'
            },
        provider: 'synergy'
      )
    end

    it 'should return the ilo sso url' do
      expect(provider.get_ilo_sso_url).to be
    end

    it 'should return the java remote sso url' do
      expect(provider.get_java_remote_sso_url).to be
    end

    it 'should return the remote console url' do
      expect(provider.get_remote_console_url).to be
    end

    it 'should return the environmental configuratition' do
      expect(provider.get_environmental_configuration).to be
    end

    it 'should return the utilization statistics' do
      expect(provider.get_utilization).to be
    end

    it 'should return firmware inventory' do
      expect(provider.get_firmware_inventory).to be
    end

    it 'should update the ilo firmware' do
      expect(provider.update_ilo_firmware).to be
    end

    it 'should raise error when a power state is not specified' do
      expect { provider.set_power_state }.to raise_error(/A "power_state" specified in data is required for this action./)
    end

    it 'should raise error when an unsupported power state is provided' do
      resource['data']['power_state'] = 'Test'
      expect { provider.set_power_state }.to raise_error(/Invalid power_state specified in data. Valid values are "On" or "Off"/)
    end

    it 'should set the power state to on' do
      resource['data']['power_state'] = 'On'
      expect(provider.set_power_state).to be
    end

    it 'should set the power state to off' do
      resource['data']['power_state'] = 'Off'
      expect(provider.set_power_state).to be
    end

    it 'should fail to set a refresh state due to missing "state" field' do
      expect { provider.set_refresh_state }.to raise_error(/A "state" specified in data is required for this action./)
    end

    it 'should be able to set a refresh state' do
      resource['data']['state'] = 'RefreshPending'
      expect(provider.set_refresh_state).to be
    end
  end
end
