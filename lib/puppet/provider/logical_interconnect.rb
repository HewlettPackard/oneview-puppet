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
    endpoint = {}
    case action
    when 'qosConfiguration'
        endpoint.store('action', 'qosConfiguration')
        endpoint.store('label', 'QoS Aggregated Configuration')
    when 'snmpConfiguration'
        endpoint.store('action', 'snmpConfiguration')
        endpoint.store('label', 'SNMP Configuration')
    when 'portMonitor'
        endpoint.store('action', 'portMonitor')
        endpoint.store('label', 'Port Monitor')
    when 'ethernetSettings'
        endpoint.store('action', 'ethernetSettings')
        endpoint.store('label', 'Ethernet Settings')
    end

    data = data_parse(data)
    log_int = OneviewSDK::LogicalInterconnect.new(@client, data)
    log_int.retrieve!
    if log_int && log_int[endpoint['action']]
        attributes = log_int[endpoint['action']]
        Puppet.notice('#{endpoint["label"]}: #{attributes}')
        return true
    elsif !log_int
        Puppet.notice('No Logical Interconnects with the given specifications '+
      'were found.')
      return false
    elsif !data[endpoint['action']]
        Puppet.notice("No #{endpoint['label']} was found in the Logical Interconnect.")
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
    log_int = OneviewSDK::LogicalInterconnect.new(@client, name: data['name'])
    log_int.retrieve!
    
    
    if log_int && data[action]
        log_int[action] = data[action]
        case action
        when 'qosConfiguration'
            log_int.update_qos_configuration
        when 'snmpConfiguration'
            log_int.update_snmp_configuration
        when 'portMonitor'
            log_int.update_port_monitor
        end
        Puppet.notice("The #{endpoint['label']} has been updated.")
        return true
    elsif !log_int
        Puppet.notice("No Logical Interconnects with the given specifications were found.")
      return false
    elsif !data[action]
        Puppet.notice("No #{endpoint['label']} has been set.")
        return false
    end

end