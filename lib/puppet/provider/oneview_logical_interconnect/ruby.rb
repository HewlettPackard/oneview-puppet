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
require 'oneview-sdk'

Puppet::Type.type(:oneview_logical_interconnect).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::LogicalInterconnect
    @data = {}
  end

  def exists?
    @data = data_parse
    empty_data_check
    variable_assignments
    li = if resource['ensure'] == :present
           resource_update(@data, @resourcetype)
           @resourcetype.find_by(@client, unique_id)
         else
           @resourcetype.find_by(@client, @data)
         end
    !li.empty?
  end

  def found
    find_resources
  end

  # GET ENDPOINTS =======================================

  def get_telemetry_configuration
    get_info('Telemetry Configuration', 'telemetryConfiguration')
  end

  def get_qos_aggregated_configuration
    get_info('QoS Aggregated Configuration', 'qosConfiguration')
  end

  def get_snmp_configuration
    get_info('SNMP Configuration', 'snmpConfiguration')
  end

  def get_port_monitor
    get_info('Port Monitor', 'portMonitor')
  end

  def get_firmware
    Puppet.notice("\n\nFirmware\n")
    pretty get_single_resource_instance.get_firmware
  end

  def get_internal_vlans
    Puppet.notice("\n\nVLAN Internal Networks\n")
    vlan_networks = get_single_resource_instance.list_vlan_networks
    Puppet.warning('There are no VLAN Networks to be displayed.') if vlan_networks.empty?
    vlan_networks.each { |net| pretty "Name: #{net[:name]}\nURI:  #{net[:uri]}\n\n" }
  end

  # PUT/SET ENDPOINTS =======================================

  def set_compliance
    Puppet.notice('Setting Logical Interconnect compliance...')
    get_single_resource_instance.compliance
  end

  def set_ethernet_settings
    resource = set_info('Ethernet Settings', 'ethernetSettings', @ethernet_settings)
    resource.update_ethernet_settings
  end

  def set_telemetry_configuration
    resource = set_info('Telemetry Configuration', 'telemetryConfiguration', @telemetry_configuration)
    resource.update_telemetry_configuration
  end

  def set_qos_aggregated_configuration
    resource = set_info('QoS Configuration', 'qosConfiguration', @qos_configuration)
    resource.update_qos_configuration
  end

  def set_snmp_configuration
    resource = set_info('SNMP Configuration', 'snmpConfiguration', @snmp_configuration)
    resource.update_snmp_configuration
  end

  def set_port_monitor
    resource = set_info('Port Monitor', 'portMonitor', @port_monitor)
    resource.update_port_monitor
  end

  def set_firmware
    Puppet.notice('Updating Firmware...')
    command = @firmware_options.delete('command')
    fw_object = OneviewSDK::FirmwareDriver.find_by(@client, fw_unique_id)
    raise('No matching firmware drivers were found in the Appliance.') unless fw_object.first
    get_single_resource_instance.firmware_update(command, fw_object.first, @firmware_options)
  end

  def set_internal_networks
    list = []
    @internal_networks.each do |net|
      type = net.delete('type')
      object = objectfromstring(type).find_by(@client, net)
      raise('No matching networks were found in the Appliance.') unless object.first
      list.push(object.first)
    end
    get_single_resource_instance.update_internal_networks(*list)
  end

  # Helpers

  def variable_assignments
    @ethernet_settings = @data.delete('ethernetSettings')
    @port_monitor = @data.delete('portMonitor')
    @snmp_configuration = @data.delete('snmpConfiguration')
    @qos_configuration = @data.delete('qosConfiguration')
    @telemetry_configuration = @data.delete('telemetryConfiguration')
    @internal_networks = @data.delete('internalNetworks')
    @firmware_options = @data.delete('firmware')
  end

  def get_info(notice, parameter)
    Puppet.notice("\n\n#{notice}\n")
    pretty get_single_resource_instance.data[parameter]
  end

  def set_info(notice, parameter, global_var)
    Puppet.notice("Updating #{notice}...")
    resource = get_single_resource_instance
    updated_hash = hash_merge(resource[parameter], global_var)
    resource[parameter] = updated_hash
    resource
  end

  def hash_merge(base_hash, new_hash)
    base_hash.each do |key, _value|
      # checks if the value is present in the new hash
      next unless new_hash[key]
      if base_hash[key].is_a?(Hash)
        base_hash[key].merge!(new_hash[key])
      else
        base_hash[key] = new_hash[key]
      end
    end
    base_hash
  end

  def fw_unique_id
    id = {}
    if @firmware_options['isoFileName']
      id['isoFileName'] = @firmware_options.delete('isoFileName')
    elsif @firmware_options['uri']
      id['uri'] = @firmware_options.delete('uri')
    else
      raise('Either the firmware iso file name or uri needs to be specified.')
    end
    id
  end
end
