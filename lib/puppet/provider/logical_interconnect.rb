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

require 'deep_merge'
require_relative 'ethernet_network'

def get_endpoints(data, action)
    case action
    when 'qosConfiguration'
        action = 'qosConfiguration'
        label  = 'QoS Aggregated Configuration'
    when 'snmpConfiguration'
        action = 'snmpConfiguration'
        label  = 'SNMP Configuration'
    when 'portMonitor'
        action = 'portMonitor'
        label  = 'Port Monitor'
    when 'ethernetSettings'
        action = 'ethernetSettings'
        label  = 'Ethernet Settings'
    when 'telemetryConfiguration'
        action = 'telemetryConfiguration'
        label  = 'Telemetry Configuration' 
    when 'firmware'
        action = 'firmware'
        label  = 'Firmware'
    when 'vlanNetworks'
        action = 'vlanNetworks'
        label  = 'VLan Networks'
    when 'schema'
        action = 'schema'
        label  = 'Schema'
    when 'forwardingInformation'
        action = 'forwardingInformation'
        label  = 'Forwarding Information Base'
    end

    data = data_parse(data)
    log_int = OneviewSDK::LogicalInterconnect.new(@client, name: data['name'])
    if log_int.retrieve!
        # special case
        if action == 'firmware'
            firmware = log_int.get_firmware
            pretty firmware
            return true
        # special case
        elsif action == 'vlanNetworks'
            vlanNetworks = log_int.list_vlan_networks
            if vlanNetworks.size > 0
                vlanNetworks.each do |net|
                    pretty "Network #{net[:name]} with uri #{net[:uri]}"
                end
            else
                Puppet.warning("No #{label} were found in the Logical Interconnect.")
            end
            return true
        # special case
        elsif action == 'schema'
            Puppet.notice("\n\n#{label}:\n")
            pretty log_int.schema
            return true
        # common cases
        elsif log_int[action]
            Puppet.notice("\n\n#{label}:\n")
            pretty log_int[action]
            return true
        end
    elsif !log_int.retrieve!
        Puppet.warning('No Logical Interconnects with the given specifications '+
        'were found.')
        return false
    elsif !log_int[action]
        Puppet.warning("No #{label} was found in the Logical Interconnect.")
        return false
    end

end


def set_endpoints(data, action)
    case action
    when 'qosConfiguration'
        action = 'qosConfiguration'
        label  = 'QoS Aggregated Configuration'
    when 'snmpConfiguration'
        action = 'snmpConfiguration'
        label  = 'SNMP Configuration'
    when 'portMonitor'
        action = 'portMonitor'
        label  = 'Port Monitor'
    when 'ethernetSettings'
        action = 'ethernetSettings'
        label  = 'Ethernet Settings'
    when 'telemetryConfiguration'
        action = 'telemetryConfiguration'
        label  = 'Telemetry Configuration'
    when 'firmware'
        action = 'firmware'
        label  = 'Firmware'
    when 'compliance'
        action = 'compliance'
        label  = 'Compliance'
    when 'internalNetworks'
        action = 'internalNetworks'
        label  = 'Internal Networks'
    end
    
    data = data_parse_interconnect(data)
    log_int = OneviewSDK::LogicalInterconnect.new(@client, name: data['name'])
    log_int_current = log_int
    log_int_current.retrieve!
    if log_int.retrieve! && data[action]
        
        case action
        when 'qosConfiguration'
            log_int[action].deep_merge!(data[action])
            log_int.update_qos_configuration
        when 'snmpConfiguration'
            log_int[action].deep_merge!(data[action])
            log_int.update_snmp_configuration
        when 'portMonitor'
            log_int[action].deep_merge!(data[action])
            log_int.update_port_monitor
        when 'telemetryConfiguration'
            log_int[action].deep_merge!(data[action])
            log_int.update_telemetry_configuration
        when 'internalNetworks'
            network = {}
            data[action].each_with_index do |(key, value), i|
                network[i] = OneviewSDK::EthernetNetwork.new(@client, data[action][key])
            end
            # TO BE VERIFIED ON MONDAY
            log_int_current.update_internal_networks(network.values.first)
        when 'firmware' #TO BE FINISHED
            firmware = OneviewSDK::FirmwareDriver.new(@client, name: data['firmware'])
            firmware_update = data['firmware']
            firmware_update.delete('operation')
            log_int.firmware_update(data['firmware']['operation'], firmware, firmware_update)
        end
        Puppet.notice("#{label} has been updated.")
        return true
    elsif action == 'compliance'
        log_int_current.compliance
        Puppet.notice("#{label} has been updated.")
        return true
    elsif !log_int.retrieve!
        Puppet.warning("No Logical Interconnects with the given specifications were found.")
      return false
    elsif !data[action]
        Puppet.warning("No #{label} has been set.")
        return false
    end

end
