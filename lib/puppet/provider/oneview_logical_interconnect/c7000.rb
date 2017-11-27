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

require_relative '../oneview_resource'

Puppet::Type.type(:oneview_logical_interconnect).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Logical Interconnects using the C7000 variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def exists?
    prepare_environment
    empty_data_check
    variable_assignments
    resource_update if resource['ensure'] == :present
    @ov_resource = @resource_type.new(@client, name: (@data.delete('name') || resource['name']))
    @ov_resource.retrieve!
  end

  def create
    raise('This resource relies on others to be created.')
  end

  def destroy
    raise('This resource relies on others to be destroyed.')
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
    true
  end

  def get_internal_vlans
    Puppet.notice("\n\nVLAN Internal Networks\n")
    vlan_networks = get_single_resource_instance.list_vlan_networks
    raise('There are no VLAN Networks to be displayed.') if vlan_networks.empty?
    vlan_networks.each { |net| pretty "Name: #{net[:name]}\nURI:  #{net[:uri]}\n\n" }
  end

  # PUT/SET ENDPOINTS =======================================

  def set_configuration
    Puppet.notice('Setting Logical Interconnect configuration...')
    @ov_resource.configuration
  end

  def set_compliance
    Puppet.notice('Setting Logical Interconnect compliance...')
    @ov_resource.compliance
  end

  def set_ethernet_settings
    Puppet.notice('Setting Ethernet settings...')
    @ov_resource.update_ethernet_settings
  end

  def set_telemetry_configuration
    Puppet.notice('Setting Telemetry configuration...')
    @ov_resource.update_telemetry_configuration
  end

  def set_qos_aggregated_configuration
    Puppet.notice('Setting QoS Configuration...')
    @ov_resource.qosConfiguration
    @ov_resource.update_qos_configuration
  end

  def set_snmp_configuration
    Puppet.notice('Setting SNMP Configuration...')
    puts "CONF:\n"
    pretty get_diff(@ov_resource['snmpConfiguration'], resource['data']['snmpConfiguration'])
    @ov_resource.update_snmp_configuration
  end

  def set_port_monitor
    Puppet.notice('Setting Port Monitor...')
    @ov_resource.update_port_monitor
  end

  def set_firmware
    Puppet.notice('Updating Firmware...')
    command = @firmware_options.delete('command')
    fw_uri = @firmware_options.delete('sspUri')
    fw_object = OneviewSDK::FirmwareDriver.find_by(@client, uri: fw_uri)
    raise('No matching firmware drivers were found in the Appliance.') unless fw_object.first
    @ov_resource.firmware_update(command, fw_object.first, @firmware_options)
  end

  def set_internal_networks
    Puppet.notice('Updating Internal Networks...')
    list = []
    @internal_networks.each do |net|
      object = OneviewSDK::EthernetNetwork.find_by(@client, name: net)
      raise("No networks matching the name #{net} were found in the Appliance.") unless object.first
      list.push(object.first)
    end
    @ov_resource.update_internal_networks(*list)
    true
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
    pretty get_single_resource_instance[parameter]
    true
  end

  # def set_info(notice, parameter, global_var)
  #   Puppet.notice("Updating #{notice}...")
  #   logical_interconnect = load_resource(:LogicalInterconnect, (@data.delete('name') || resource['name']))
  #   Puppet.debug('AFTER LOAD')
  #   Puppet.debug("notice: #{notice}\n parameter: #{parameter}\n global_var: #{global_var}")
  #   updated_hash = hash_merge(resource[parameter], global_var)
  #   Puppet.debug('AFTER MERGE')
  #   logical_interconnect[parameter] = updated_hash
  #   Puppet.debug('AFTER PARAMETER ASSIGN')
  #   logical_interconnect
  # end
  #
  # def hash_merge(base_hash, new_hash)
  #   base_hash.each do |key, _value|
  #     # checks if the value is present in the new hash
  #     next unless new_hash[key]
  #     if base_hash[key].is_a?(Hash)
  #       base_hash[key].merge!(new_hash[key])
  #     else
  #       base_hash[key] = new_hash[key]
  #     end
  #   end
  #   base_hash
  # end
end
