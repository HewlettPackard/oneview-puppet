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
    li = if resource['ensure'] == :present
           resource_update
           @resource_type.find_by(@client, unique_id)
         else
           @resource_type.find_by(@client, @data)
         end
    !li.empty?
  end

  def self.api_version
    2400
  end

  def create
    raise('This resource relies on others to be created.')
  end

  def destroy
    raise('This resource relies on others to be destroyed.')
  end

  def bulk_inconsistency_validate
    inconsistency_validation = @resource_type.new(@client)
    inconsistency_validation.data['uri'] = @data['logical_interconnect_uris'].first
    li_name = @data['logical_interconnect_uris'] if @data['logical_interconnect_uris']
    li_uri = OneviewSDK.resource_named(:LogicalInterconnect, api_version, resource_variant).find_by(@client, name: li_name)
    @data['logical_interconnect_uris'] = li_uri.first['uri']
    inconsistency_validation.data['logicalInterconnectUris'] = @data['logical_interconnect_uris']

    response = inconsistency_validation.bulk_inconsistency_validate
    pretty response.data['logicalInterconnectsReport']
    true
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
    get_single_resource_instance.configuration
    true
  end

  def set_compliance
    Puppet.notice('Setting Logical Interconnect compliance...')
    get_single_resource_instance.compliance
    true
  end

  def get_igmp_settings
    get_info('IGMP Settings', 'igmpSettings')
  end

  def set_igmp_settings
    resource = set_info('IGMP Settings', 'igmpSettings', @igmp_settings)
    resource.update_igmp_settings
    true
  end

  def set_ethernet_settings
    resource = set_info('Ethernet Settings', 'ethernetSettings', @ethernet_settings)
    resource.update_ethernet_settings
    true
  end

  def set_port_flap_settings
    resource = set_info('Port Flap Settings', 'portFlapProtection', @port_flap_settings)
    resource.update_port_flap_settings
    true
  end

  def set_telemetry_configuration
    resource = set_info('Telemetry Configuration', 'telemetryConfiguration', @telemetry_configuration)
    resource.update_telemetry_configuration
    true
  end

  def set_qos_aggregated_configuration
    resource = set_info('QoS Configuration', 'qosConfiguration', @qos_configuration)
    resource.update_qos_configuration
    true
  end

  def set_snmp_configuration
    resource = set_info('SNMP Configuration', 'snmpConfiguration', @snmp_configuration)
    resource.update_snmp_configuration
    true
  end

  def set_port_monitor
    resource = set_info('Port Monitor', 'portMonitor', @port_monitor)
    resource.update_port_monitor
    true
  end

  def set_firmware
    Puppet.notice('Updating Firmware...')
    command = @firmware_options.delete('command')
    fw_uri = @firmware_options.delete('sspUri')
    fw_object = OneviewSDK::FirmwareDriver.find_by(@client, uri: fw_uri)
    raise('No matching firmware drivers were found in the Appliance.') unless fw_object.first
    get_single_resource_instance.firmware_update(command, fw_object.first, @firmware_options)
    true
  end

  def set_internal_networks
    Puppet.notice('Updating Internal Networks...')
    list = []
    @internal_networks.each do |net|
      object = OneviewSDK::EthernetNetwork.find_by(@client, name: net)
      raise('No matching networks were found in the Appliance.') unless object.first
      list.push(object.first)
    end
    get_single_resource_instance.update_internal_networks(*list)
    true
  end

  # Helpers

  def variable_assignments
    @ethernet_settings = @data.delete('ethernetSettings')
    @igmp_settings = @data.delete('igmpSettings')
    @port_monitor = @data.delete('portMonitor')
    @port_flap_settings = @data.delete('portFlapProtection')
    @snmp_configuration = @data.delete('snmpConfiguration')
    @qos_configuration = @data.delete('qosConfiguration')
    @telemetry_configuration = @data.delete('telemetryConfiguration')
    @internal_networks = @data.delete('internalNetworks')
    @firmware_options = @data.delete('firmware')
  end

  def get_info(notice, parameter)
    Puppet.notice("\n\n#{notice}\n")
    pretty get_single_resource_instance.data[parameter]
    true
  end

  def set_info(notice, parameter, global_var)
    Puppet.notice("Updating #{notice}...")
    resource = get_single_resource_instance
    updated_hash = hash_merge(resource[parameter], global_var)
    resource[parameter] = updated_hash
    resource
  end

  def hash_merge(base_hash, new_hash)
    base_hash.each_key do |key|
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
end
