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

Puppet::Type::Oneview_sas_logical_interconnect.provide :synergy, parent: Puppet::OneviewResource do
  desc 'Provider for OneView SAS Logical Interconnects using the Synergy variant of the OneView API'

  confine true: login[:hardware_variant] == 'Synergy'

  mk_resource_methods

  def resource_name
    'SASLogicalInterconnect'
  end

  def self.resource_name
    'SASLogicalInterconnect'
  end

  def exists?
    @data = data_parse
    empty_data_check
    variable_assignments
    # puts "\n\n exists: #{@resourcetype.new(@client, @data).exists?}"
    # li = if resource['ensure'] == :present
    #        resource_update(@data, @resourcetype)
    #        @resourcetype.find_by(@client, unique_id)
    #      else
    #        @resourcetype.find_by(@client, @data)
    #      end
    # !li.empty?
    @resourcetype.new(@client, @data).exists?
  end

  def create
    raise('This resource relies on others to be created.')
  end

  def destroy
    raise('This resource relies on others to be destroyed.')
  end

  def get_firmware
    Puppet.notice("\n\nFirmware\n")
    pretty get_single_resource_instance.get_firmware
    true
  end

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

  def set_firmware
    Puppet.notice('Updating Firmware...')
    command = @firmware_options.delete('command')
    fw_uri = @firmware_options.delete('sspUri')
    fw_object = OneviewSDK::FirmwareDriver.find_by(@client, uri: fw_uri)
    raise('No matching firmware drivers were found in the Appliance.') unless fw_object.first
    get_single_resource_instance.firmware_update(command, fw_object.first, @firmware_options)
    true
  end

  def replace_drive_enclosure
    Puppet.notice('Replacing drive enclosure...')
    raise 'This ensure requires the fields "oldSerialNumber" and "newSerialNumber" on data.' unless
      @drive_options_old_serial && @drive_options_new_serial
    pretty get_single_resource_instance.replace_drive_enclosure(@drive_options_old_serial, @drive_options_new_serial)
    true
  end

  # Helpers

  def variable_assignments
    @firmware_options = @data.delete('firmware')
    @drive_options_old_serial = @data.delete('oldSerialNumber')
    @drive_options_new_serial = @data.delete('newSerialNumber')
  end
end
