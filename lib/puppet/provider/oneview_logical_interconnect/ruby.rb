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

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'login'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'logical_interconnect'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_logical_interconnect).provide(:ruby) do

  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
  end

  def exists?
  end

  def found
    data = data_parse(resource['data'])
    log_int = OneviewSDK::LogicalInterconnect.new(@client, name: data['name'])
    if log_int.retrieve!
      Puppet.notice ( "\n\nFound logical interconnect"+
      " #{log_int['name']} on Oneview Appliance\n")
      return true
    else
      Puppet.notice("\n\nNo logical interconnects with the specified data were"+
      " found on the Oneview Appliance\n")
      return false
    end
  end

  # GET ENDPOINTS =======================================

  def get_ethernet_settings
    get_endpoints(resource['data'], 'ethernetSettings')
  end

  def get_telemetry_configuration
    get_endpoints(resource['data'], 'telemetryConfiguration')
  end

  def get_qos_aggregated_configuration
    get_endpoints(resource['data'], 'qosConfiguration')
  end

  def get_snmp_configuration
    get_endpoints(resource['data'], 'snmpConfiguration')
  end

  def get_port_monitor
    get_endpoints(resource['data'], 'portMonitor')
  end



  # PUT/SET ENDPOINTS =======================================

  def set_qos_aggregated_configuration
    set_endpoints(resource['data'], 'qosConfiguration')
  end

  
  


#   def set_ethernet_settings
#     data = data_parse(resource['data'])
#     if data['ethernetSettings']
#       current_data = data.delete('ethernetSettings')
#       log_int = OneviewSDK::LogicalInterconnect.new(@client, current_data).retrieve!
#       if log_int
#         log_int['ethernetSettings'] = data['ethernetSettings']
#         log_int.update_ethernet_settings
#         return true
#       else
#         Puppet.notice('No Logical Interconnect with the given specifications were found.')
#         return false
#       end
#     else
#       Puppet.notice('No Ethernet Settings were defined in the manifest.')
#       return false
#     end
#   end

#   def get_firmware
#     data = data_parse(resource['data'])
#     log_int = OneviewSDK::LogicalInterconnect.new(@client, data).retrieve!
#     firmware = log_int.get_firmware
#     if firmware
#       Puppet.notice('Logical interconnect firmware:\n\n #{firmware}')
#       return true
#     else
#       Puppet.notice('No firmware was found for this logical interconnect.')
#       return false
#     end
#   end

#   def set_firmware
#     data = data_parse(resource['data'])
#     log_int = OneviewSDK::LogicalInterconnect.new(@client, name: data['firmware']['name']).retrieve!
#     if !log_int
#       Puppet.notice('No Logical Interconnect with the given specifications '+
#       'were found.')
#       return false
#     elsif data['firmware_options']
#       # firmware log_int.get_firmware
#       firmware_options = data['firmware_options']
#       operation = firmware_options['operation']
#       firmware_options.delete('operation')
#       firmware = OneviewSDK::FirmwareDriver.new(@client, log_int.get_firmware)
#       log_int.firmare_update(operation, firmware, firmware_options)
#       return true
#     else
#       Puppet.notice('No firmware options were defined in the manifest.')
#       return false
#     end
#   end

#   # has to be checked within the sdk
#   # def get_forwarding_information_base
#   #   data = data_parse(resource['data'])
#   #   log_int = OneviewSDK::LogicalInterconnect.new(@client, current_data).retrieve!
#   # end

#   def set_internal_networks
#     data = data_parse(resource['data'])
#     current_data = data.delete('ethernet_networks')
#     log_int = OneviewSDK::LogicalInterconnect.new(@client, current_data).retrieve!
#     if !log_int
#       Puppet.notice('No Logical Interconnect with the given specifications '+
#       'were found.')
#     elsif data['ethernet_networks']
#       ethernet_networks = data['ethernet_networks']
#       ethernet_networks.each { |network| network.create! }
#       #to be confirmed whether it takes many networks at once
#       log_int.update_internal_networks(ethernet_networks)
#       return true
#     else
#       Puppet.notice('No ethernet networks were defined in the manifest.')
#       return false
#     end
#   end

#   def get_internal_vlans
#     data = data_parse(resource['data'])
#     log_int = OneviewSDK::LogicalInterconnect.new(@client, data).retrieve!
#     if !log_intgit
#       Puppet.notice('No Logical Interconnect with the given specifications '+
#       'were found.')
#       return false
#     else
#       internal_networks = log_int.list_vlan_networks
#       if internal_networks.size > 0
#         internal_networks.each { |net| puts "Network #{net['name']} with uri "+
#         "#{net['uri']}."}
#         return true
#       else
#         Puppet.notice('No Internal Vlans were found.')
#         return false
#       end
#     end
#   end

#   def get_qos_aggregated_configuration
#     data = data_parse(resource['data'])
#     log_int = OneviewSDK::LogicalInterconnect.new(@client, data).retrieve!
#     if !log_int
#       Puppet.notice('No Logical Interconnects with the given specifications '+
#       'were found.')
#       return false
#     elsif log_int['qosConfiguration']
#       Puppet.notice('QoS Aggregated Configuration: #{log_int["qosConfiguration"]}')
#       return true
#     else
#       Puppet.notice('No QoS Aggregated Configuration was found.')
#       return false
#     end
#   end

#   def set_qos_aggregated_configuration
#     data = data_parse(resource['data'])
#     if data['qosConfiguration']
#       current_data = data_parse(resource['data'])
#       log_int = OneviewSDK::LogicalInterconnect.new(@client, current_data).retrieve!
#       log_int['qosConfiguration'] = data['qosConfiguration']
#       log_int.update_qos_configuration
#       Puppet.notice('The QoS Aggregated Configuration has been updated.')
#       return true
#     else
#       Puppet.notice('No QoS Aggregated Configuration was found.')
#       return false
#     end
#   end

#   def get_snmp_configuration
#     data = data_parse(resource['data'])
#     log_int = OneviewSDK::LogicalInterconnect.new(@client, data).retrieve!
#     if !log_int
#       Puppet.notice('No Logical Interconnects with the given specifications '+
#       'were found.')
#       return false
#     elsif log_int['qosConfiguration']
#       Puppet.notice('SNMP Configuration: #{log_int["snmpConfiguration"]}')
#       return true
#     else
#       Puppet.notice('No SNMP Configuration was found.')
#       return false
#     end
#   end

# # TO BE TAKEN AS EXAMPLE
#   def set_snmp_configuration
#     data = data_parse(resource['data'])
#     current_data = data.delete('snmpConfiguration')
#     log_int = OneviewSDK::LogicalInterconnect.new(@client, current_data).retrieve!
#     if log_int && data['snmpConfiguration']
#       log_int['snmpConfiguration'] = data['snmpConfiguration']
#       log_int.update_snmp_configuration
#       Puppet.notice('The SNMP Configuration has been updated.')
#       return true
#     elsif !data['snmpConfiguration']
#       Puppet.notice('No SNMP Configuration was found.')
#       return false
#     else
#       Puppet.notice('No Logical Interconnects with the given specifications '+
#       'were found.')
#       return false
#     end
#   end

#   def get_port_monitor
#     data = data_parse(resource['data'])
#     log_int = OneviewSDK::LogicalInterconnect.new(@client, data).retrieve!
#     if log_int && log_int['portMonitor']
#       Puppet.notice('Port Monitor: #{log_int["portMonitor"]}')
#       return true
#     elsif !log_int
#       Puppet.notice('No Logical Interconnects with the given specifications '+
#       'were found.')
#       return false
#     else
#       Puppet.notice('No Port Monitor was found.')
#       return false
#     end
#   end

#   def set_port_monitor
#     data = data_parse(resource['data'])
#     current_data = data.delete('portMonitor')
#     log_int = OneviewSDK::LogicalInterconnect.new(@client, current_data).retrieve!
#     if log_int && data['portMonitor']
#       log_int['portMonitor'] = data['portMonitor']
#       log_int.update_port_monitor
#       Puppet.notice('The Port Monitor has been updated.')
#       return true
#     elsif !log_int
#       Puppet.notice('No Logical Interconnects with the given specifications '+
#       'were found.')
#       return false
#     else
#       Puppet.notice('No Port Monitor was found.')
#       return false
#     end
#   end


#   def get_telemetry_configurations
#     data = data_parse(resource['data'])
#     log_int = OneviewSDK::LogicalInterconnect.new(@client, data).retrieve!
#     if log_int && log_int['telemetryConfiguration']
#       Puppet.notice('Telemetry Configuration: #{log_int["telemetryConfiguration"]}')
#       return true
#     elsif !log_int
#       Puppet.notice('No Logical Interconnects with the given specifications '+
#       'were found.')
#       return false
#     else
#       Puppet.notice('No Telemetry Configuration was found.')
#       return false
#     end
#   end

end
