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

provider_class = Puppet::Type.type(:oneview_server_hardware).provider(:oneview_server_hardware)
resourcetype = OneviewSDK::ServerHardware

describe provider_class, unit: true do
  include_context 'shared context'

  @resourcetype = OneviewSDK::ServerHardware
  let(:resource) do
    Puppet::Type.type(:oneview_server_hardware).new(
      name: 'server_hardware',
      ensure: 'found',
      data:
          {
            'hostname' => '172.18.6.5'
          }
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters before server creation' do
    it 'should be an instance of the provider oneview_server_hardware' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_server_hardware).provider(:oneview_server_hardware)
    end

    it 'should raise error when server is not found' do
      allow(OneviewSDK::ServerHardware).to receive(:find_by).with(anything, {}).and_return([])
      expect { provider.found }.to raise_error(/No ServerHardware with the specified data were found on the Oneview Appliance/)
    end
  end

  context 'given the create parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_server_hardware).new(
        name: 'server_hardware',
        ensure: 'present',
        data:
            {
              'hostname'        => '172.18.6.5',
              'username'        => 'dcs',
              'password'        => 'dcs',
              'licensingIntent' => 'OneView'
            }
      )
    end
    it 'should be able to run through self.instances' do
      allow(OneviewSDK::ServerHardware).to receive(:get_all).with(anything).and_return(%w(test1 test2 test3))
      expect(instance).to be
    end

    it 'should be able to create the resource' do
      allow(resourcetype).to receive(:find_by).and_return([])
      allow_any_instance_of(resourcetype).to receive(:add).and_return(resourcetype.new(@client, resource['data']))
      expect(provider.exists?).to eq(false)
      expect(provider.create).to be
    end
  end

  context 'given the minimum parameters after server creation' do
    before(:each) do
      resource['data']['uri'] = '/rest/server-hardware/fake'
      test = OneviewSDK::ServerHardware.new(@client, resource['data'])
      allow(OneviewSDK::ServerHardware).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(FakeResponse.new('Fake Get Statistics'))
      path = 'spec/support/fixtures/unit/provider/server_hardware.json'
      fake_json_response = File.read(path)
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(fake_json_response)
      provider.exists?
    end

    it 'should return the bios' do
      expect(provider.get_bios).to be
    end

    it 'should return the ilo sso url' do
      expect(provider.get_ilo_sso_url).to be
    end

    it 'should return the java remote sso url' do
      expect(provider.get_java_remote_sso_url).to be
    end
    #
    it 'should return the remote console url' do
      expect(provider.get_remote_console_url).to be
    end

    it 'should return the environmental configuratition' do
      expect(provider.get_environmental_configuration).to be
    end

    it 'should return the utilization statistics' do
      expect(provider.get_utilization).to be
    end
  end

  context 'given the minimum parameters for the SET methods' do
    before(:each) do
      resource['data']['uri'] = '/rest/server-hardware/fake'
      test = OneviewSDK::ServerHardware.new(@client, resource['data'])
      allow(OneviewSDK::ServerHardware).to receive(:find_by).with(anything, resource['data']).and_return([test])
      path = 'spec/support/fixtures/unit/provider/server_hardware.json'
      fake_json_response = File.read(path)
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(fake_json_response)
      provider.exists?
    end

    it 'should update the ilo firmware' do
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_put).and_return(FakeResponse.new('Fake Get Statistics'))
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
      allow_any_instance_of(OneviewSDK::ServerHardware).to receive(:power_on).with(false).and_return('Test')
      expect(provider.set_power_state).to be
    end

    it 'should set the power state to off' do
      resource['data']['power_state'] = 'Off'
      allow_any_instance_of(OneviewSDK::ServerHardware).to receive(:power_off).with(false).and_return('Test')
      expect(provider.set_power_state).to be
    end

    it 'should fail to set a refresh state due to missing "state" field' do
      expect { provider.set_refresh_state }.to raise_error(/A "state" specified in data is required for this action./)
    end

    it 'should be able to set a refresh state' do
      resource['data']['state'] = 'RefreshPending'
      allow_any_instance_of(OneviewSDK::ServerHardware).to receive(:set_refresh_state).with('RefreshPending', {}).and_return('Test')
      expect(provider.set_refresh_state).to be
    end

    it 'should delete the server hardware' do
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.destroy).to be
    end
  end
end
