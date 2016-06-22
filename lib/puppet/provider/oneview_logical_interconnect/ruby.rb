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
    state = resource['ensure']
    data = data_parse(resource['data'])

    log_int = OneviewSDK::LogicalInterconnect.new(@client, name: data['name'])
    log_int_exists = log_int.retrieve!
    log_int_exists
    return true
  end

  def create
    puts 'created'
  end

  def destroy
    puts 'destroyed'
  end

  def found
    data = data_parse(resource['data'])
    log_int = OneviewSDK::LogicalInterconnect.new(@client, data).retrieve!

    if log_int
      Puppet.notice ( "\n\nFound logical interconnect"+
      " #{log_int['name']} (URI: #{log_int['uri']}) on Oneview Appliance\n")
      return true
    else
      Puppet.notice("\n\nNo logical interconnects with the specified data were"+
      " found on the Oneview Appliance\n")
      return false
    end

  end

  def set_ethernet_settings
    data = data_parse(resource['data'])
    if data['ethernetSettings']
      current_data = data.delete('ethernetSettings')
      log_int = OneviewSDK::LogicalInterconnect.new(@client, current_data).retrieve!
      if log_int
        log_int['ethernetSettings'] = data['ethernetSettings']
        log_int.update_ethernet_settings
        return true
      else
        Puppet.notice('No Logical Interconnect with the given specifications were found.')
        return false
      end
    else
      Puppet.notice('No Ethernet Settings were defined in the manifest.')
      return false
    end
  end

  def get_firmware
    data = data_parse(resource['data'])
    log_int = OneviewSDK::LogicalInterconnect.new(@client, data).retrieve!
    firmware = log_int.get_firmware
    if firmware
      Puppet.notice('Logical interconnect firmware:\n\n #{firmware}')
      return true
    else
      Puppet.notice('No firmware was found for this logical interconnect.')
      return false
    end
  end

  def set_firmware
    data = data_parse(resource['data'])
    log_int = OneviewSDK::LogicalInterconnect.new(@client, current_data).retrieve!
    if !log_int
      Puppet.notice('No Logical Interconnect with the given specifications '+
      'were found.')
      return false
    elsif data['firmware_options']
      # firmware log_int.get_firmware
      firmware_options = data['firmware_options']
      operation = firmware_options['operation']
      firmware_options.delete('operation')
      firmware = OneviewSDK::FirmwareDriver.new(@client, log_int.get_firmware)
      log_int.firmare_update(operation, firmware, firmware_options)
      return true
    else
      Puppet.notice('No firmware options were defined in the manifest.')
      return false
    end
  end

  # has to be checked within the sdk
  # def get_forwarding_information_base
  #   data = data_parse(resource['data'])
  #   log_int = OneviewSDK::LogicalInterconnect.new(@client, current_data).retrieve!
  # end

  def set_internal_networks
    data = data_parse(resource['data'])
    current_data = data.delete('ethernet_networks')
    log_int = OneviewSDK::LogicalInterconnect.new(@client, current_data).retrieve!
    if !log_int
      Puppet.notice('No Logical Interconnect with the given specifications '+
      'were found.')
    elsif data['ethernet_networks']
      ethernet_networks = data['ethernet_networks']
      ethernet_networks.each { |network| network.create! }
      log_int.update_internal_networks(ethernet_networks) #to be confirmed whether it takes many networks at once
      return true
    else
      Puppet.notice('No ethernet networks were defined in the manifest.')
      return false
    end
  end

  def get_internal_vlans
    data = data_parse(resource['data'])
    log_int = OneviewSDK::LogicalInterconnect.new(@client, data).retrieve!
    if !log_intgit
      Puppet.notice('No Logical Interconnect with the given specifications '+
      'were found.')
    else
      internal_networks = log_int.list_vlan_networks
      if internal_networks.size > 0
        internal_networks.each { |net| puts "Network #{net['name']} with uri "+
        "#{net['uri']}."}
      else
        Puppet.notice('No Internal Vlans were found.')
      end
    end
  end

  def get_qos_aggregated_configuration
    data = data_parse(resource['data'])
    log_int = OneviewSDK::LogicalInterconnect.new(@client, data).retrieve!
    if !log_int
      Puppet.notice('No Logical Interconnects with the given specifications '+
      'were found.')
    elsif log_int['qosConfiguration']
      Puppet.notice('QoS Aggregated Configuration: #{log_int["qosConfiguration"]}')
    else
      Puppet.notice('No QoS Aggregated Configuration was found.')
    end
  end

  def set_qos_aggregated_configuration
    data = data_parse(resource['data'])
    if data['qosConfiguration']
      log_int = OneviewSDK::LogicalInterconnect.new(@client, data)
      log_int.update_qos_configuration
    else
      Puppet.notice('No QoS Aggregated Configuration was found.')
    end
  end

end
