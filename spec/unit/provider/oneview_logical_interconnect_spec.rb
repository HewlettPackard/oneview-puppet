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
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_logical_interconnect).provider(:oneview_logical_interconnect)
resourcetype = OneviewSDK::LogicalInterconnect

describe provider_class, unit: true do
  include_context 'shared context'
  context 'given the min parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_logical_interconnect).new(
        name: 'LI',
        ensure: 'present',
        data:
            {
              'name' => 'Encl2-my enclosure logical interconnect group',
              'internalNetworks' => ['NET'],
              'snmpConfiguration' =>
              {
                'enabled' => true
              },
              'portMonitor' =>
              {
                'enablePortMonitor' => false
              },
              'telemetryConfiguration' =>
              {
                'enableTelemetry' => true
              },
              'qosConfiguration' =>
              {
                'activeQosConfig' =>
                {
                  'configType' => 'Passthrough'
                }
              }
            }
      )
    end

    let(:provider) { resource.provider }

    let(:instance) { provider.class.instances.first }

    before(:each) do
      test = resourcetype.new(@client, resource['data'])
      allow(resourcetype).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
    end

    it 'should be an instance of the provider' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_interconnect)
        .provider(:oneview_logical_interconnect)
    end

    it 'return false when the resource does not exists' do
      allow(resourcetype).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
    end

    it 'should find the resource' do
      expect(provider.found).to be
    end

    it 'should be able to get the qos configuration' do
      allow_any_instance_of(resourcetype).to receive(:get_qos_aggregated_configuration).and_return('Test')
      expect(provider.get_qos_aggregated_configuration).to be
    end

    it 'should be able to get the port monitor' do
      allow_any_instance_of(resourcetype).to receive(:get_port_monitor).and_return('Test')
      expect(provider.get_port_monitor).to be
    end

    it 'should be able to get the firmware' do
      allow_any_instance_of(resourcetype).to receive(:get_firmware).and_return('Test')
      expect(provider.get_firmware).to be
    end

    it 'should be able to get the vlans' do
      test_network = OneviewSDK::EthernetNetwork.new(@client, name: 'NET')
      allow(OneviewSDK::EthernetNetwork).to receive(:find_by).with(anything, name: 'NET').and_return([test_network])
      allow_any_instance_of(resourcetype).to receive(:list_vlan_networks).and_return([test_network])
      expect(provider.get_internal_vlans).to be
    end

    it 'should be able to get the snmp configuration' do
      allow_any_instance_of(resourcetype).to receive(:get_snmp_configuration).and_return('Test')
      expect(provider.get_snmp_configuration).to be
    end

    it 'should be able to add an internal network' do
      test_network = OneviewSDK::EthernetNetwork.new(@client, name: 'NET')
      allow(OneviewSDK::EthernetNetwork).to receive(:find_by).with(anything, name: 'NET').and_return([test_network])
      expect_any_instance_of(resourcetype).to receive(:update_internal_networks)
        .with(test_network).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.set_internal_networks).to be
    end

    it 'should be able to set the compliance' do
      expect_any_instance_of(resourcetype).to receive(:compliance).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.set_compliance).to be
    end

    it 'should be able to update the snmp configuration' do
      expect_any_instance_of(resourcetype).to receive(:update_snmp_configuration).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.set_snmp_configuration).to be
    end

    it 'should be able to update the port monitor' do
      expect_any_instance_of(resourcetype).to receive(:update_port_monitor).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.set_port_monitor).to be
    end

    it 'should be able to set the configuration' do
      expect_any_instance_of(resourcetype).to receive(:configuration).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.set_configuration).to be
    end

    it 'should be able to set the telemetry configuration' do
      expect_any_instance_of(resourcetype).to receive(:update_telemetry_configuration).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.set_telemetry_configuration).to be
    end

    it 'should be able to set the qos configuration' do
      expect_any_instance_of(resourcetype).to receive(:update_qos_configuration).and_return(FakeResponse.new('uri' => '/rest/fake'))
      expect(provider.set_qos_aggregated_configuration).to be
    end
  end
end
