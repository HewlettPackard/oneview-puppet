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
    end

    data = data_parse(data)
    log_int = OneviewSDK::LogicalInterconnect.new(@client, name: data['name'])
    if log_int.retrieve! && log_int[action]
        Puppet.notice("\n\n#{label}:\n")
        pretty log_int[action]
        return true
    elsif !log_int.retrieve!
        Puppet.notice('No Logical Interconnects with the given specifications '+
      'were found.')
      return false
    elsif !log_int[action]
        Puppet.notice("No #{label} was found in the Logical Interconnect.")
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
    end
    
    data = data_parse(data)
    puts data[action]
    log_int = OneviewSDK::LogicalInterconnect.new(@client, name: data['name'])
    if log_int.retrieve! && data[action]
        puts log_int[action]
        log_int[action].merge(data[action])
        case action
        when 'qosConfiguration'
            puts log_int[action]
            # log_int.update_qos_configuration
        when 'snmpConfiguration'
            log_int.update_snmp_configuration
        when 'portMonitor'
            log_int.update_port_monitor
        end
        Puppet.notice("The # has been updated.")
        return true
    elsif !log_int.retrieve!
        Puppet.notice("No Logical Interconnects with the given specifications were found.")
      return false
    elsif !data[action]
        Puppet.notice("No  has been set.")
        return false
    end

end