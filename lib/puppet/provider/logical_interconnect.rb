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
    # when 'compliance'
    #     action = 'compliance'
    #     label  = 'Compliance'   
    end

    data = data_parse(data)
    log_int = OneviewSDK::LogicalInterconnect.new(@client, name: data['name'])
    if log_int.retrieve!
        if action == 'firmware'
            firmware = log_int.get_firmware
            pretty firmware
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
    end
    
    data = data_parse(data)
    log_int = OneviewSDK::LogicalInterconnect.new(@client, name: data['name'])
    log_int_current = log_int
    log_int_current.retrieve!
    if log_int.retrieve! && data[action]
        log_int[action].deep_merge!(data[action])
        case action
        when 'qosConfiguration'
            log_int.update_qos_configuration
        when 'snmpConfiguration'
            log_int.update_snmp_configuration
        when 'portMonitor'
            log_int.update_port_monitor
        when 'telemetryConfiguration'
            log_int.update_telemetry_configuration
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