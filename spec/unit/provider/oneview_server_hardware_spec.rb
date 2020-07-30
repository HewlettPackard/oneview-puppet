################################################################################
# (C) Copyright 2016-2020 Hewlett Packard Enterprise Development LP
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

provider_class = Puppet::Type.type(:oneview_server_hardware).provider(:c7000)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:ServerHardware, api_version, :C7000)

describe provider_class, unit: true do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_server_hardware).new(
      name: 'server_hardware',
      ensure: 'found',
      data:
          {
            'hostname' => '172.18.6.5'
          },
      provider: 'c7000'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test) { resource_type.new(@client, resource['data']) }

  before(:each) do
    allow(resource_type).to receive(:find_by).and_return([test])
    allow(resource_type).to receive(:get_all).and_return([test])
    provider.exists?
  end

  context 'given the minimum parameters before server creation' do
    it 'should be an instance of the provider c7000' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_server_hardware).provider(:c7000)
    end

    it 'should raise error when server is not found' do
      allow(resource_type).to receive(:find_by).and_return([])
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
            },
        provider: 'c7000'
      )
    end
    it 'should be able to run through self.instances' do
      expect(instance).to be
    end

    it 'should be able to create the resource' do
      allow(resource_type).to receive(:find_by).and_return([])
      allow_any_instance_of(resource_type).to receive(:add).and_return(resource_type.new(@client, resource['data']))
      expect(provider.exists?).to eq(false)
      expect(provider.create).to be
    end
  end

  context 'given parameters to add multiple servers' do
    let(:resource) do
      Puppet::Type.type(:oneview_server_hardware).new(
        name: 'server_hardware',
        ensure: 'add_multiple_servers',
        data:
            {
              'hostname'        => '172.18.6.5',
              'username'        => 'dcs',
              'password'        => 'dcs',
              'licensingIntent' => 'OneView',
              'mpHostsAndRanges' => ['172.18.6.13-172.18.6.14']
            },
        provider: 'c7000'
      )
    end

    it 'should be able to create the resource' do
      allow_any_instance_of(resource_type).to receive(:add_multiple_servers).and_return('fake')
      expect(provider.add_multiple_servers).to be
    end
  end

  context 'given the minimum parameters after server creation' do
    before(:each) do
      resource['data']['uri'] = '/rest/server-hardware/fake'
      test = resource_type.new(@client, resource['data'])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
    end

    it 'should return the bios' do
      expect_any_instance_of(resource_type).to receive(:get_bios).and_return('Fake Get BIOS')
      expect(provider.get_bios).to be
    end

    it 'should return the local storage' do
      expect_any_instance_of(resource_type).to receive(:get_local_storage).and_return('Fake Get Local Storage')
      expect(provider.get_local_storage).to be
    end

    it 'should return the local storagev2' do
      expect_any_instance_of(resource_type).to receive(:get_local_storagev2).and_return('Fake Get Local StorageV2')
      expect(provider.get_local_storagev2).to be
    end

    it 'should return the ilo sso url' do
      expect_any_instance_of(resource_type).to receive(:get_ilo_sso_url).and_return('Fake get_ilo_sso_url')
      expect(provider.get_ilo_sso_url).to be
    end

    it 'should return the java remote sso url' do
      expect_any_instance_of(resource_type).to receive(:get_java_remote_sso_url).and_return('Fake get_java_remote_sso_url')
      expect(provider.get_java_remote_sso_url).to be
    end

    it 'should return the remote console url' do
      expect_any_instance_of(resource_type).to receive(:get_remote_console_url).and_return('Fake get_remote_console_url')
      expect(provider.get_remote_console_url).to be
    end

    it 'should return the environmental configuratition' do
      expect_any_instance_of(resource_type).to receive(:environmental_configuration).and_return('Fake get_environmental_configuration')
      expect(provider.get_environmental_configuration).to be
    end

    it 'should return the utilization statistics' do
      expect_any_instance_of(resource_type).to receive(:utilization).and_return('Fake get_utilization')
      expect(provider.get_utilization).to be
    end

    it 'should return the firmware inventory' do
      expect_any_instance_of(resource_type).to receive(:get_firmware_by_id).and_return('Fake get_firmware_inventory')
      expect(provider.get_firmware_inventory).to be
    end

    it 'should return the physical server hardware details' do
      expect_any_instance_of(resource_type).to receive(:get_physical_server_hardware).and_return('Fake get_physical_server_hardware')
      expect(provider.get_physical_server_hardware).to be
    end
  end

  context 'given the minimum parameters for the SET methods' do
    before(:each) do
      resource['data']['uri'] = '/rest/server-hardware/fake'
      test = resource_type.new(@client, resource['data'])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
    end

    it 'should update the ilo firmware' do
      expect_any_instance_of(resource_type).to receive(:update_ilo_firmware).and_return(test)
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
      allow_any_instance_of(resource_type).to receive(:power_on).with(false).and_return('Test')
      expect(provider.set_power_state).to be
    end

    it 'should set the power state to off' do
      resource['data']['power_state'] = 'Off'
      allow_any_instance_of(resource_type).to receive(:power_off).with(false).and_return('Test')
      expect(provider.set_power_state).to be
    end

    it 'should fail to set a refresh state due to missing "state" field' do
      expect { provider.set_refresh_state }.to raise_error(/A "state" specified in data is required for this action./)
    end

    it 'should be able to set a refresh state' do
      resource['data']['state'] = 'RefreshPending'
      allow_any_instance_of(resource_type).to receive(:set_refresh_state).with('RefreshPending', {}).and_return('Test')
      expect(provider.set_refresh_state).to be
    end

    it 'should delete the server hardware' do
      expect_any_instance_of(resource_type).to receive(:remove).and_return({})
      expect(provider.destroy).to be
    end
  end

  context 'given the patch parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_server_hardware).new(
        name: 'server_hardware',
        ensure: 'present',
        data:
            {
              'hostname' => '172.18.6.6',
              'op'       => 'add',
              'path'     => '/scopeUris/-',
              'value'    => '/rest/scopes/3b292baf-8b59-4671-9e5c-deca07496c60'
            },
        provider: 'c7000'
      )
    end
    it '#patch should be able to run patch operations' do
      allow_any_instance_of(resource_type).to receive(:patch).and_return(test)
      expect(provider.create).to be
    end
  end
end
