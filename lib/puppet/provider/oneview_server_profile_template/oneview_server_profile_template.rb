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

Puppet::Type.type(:oneview_server_profile_template).provide(:oneview_server_profile_template) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::ServerProfileTemplate
    @data = {}
  end

  def exists?
    @data = data_parse
    empty_data_check
    variable_assignments
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    return true if resource_update(@data, @resourcetype)
    @resourcetype.new(@client, @data).create
  end

  def destroy
    get_single_resource_instance.delete
  end

  def found
    find_resources
  end

  def get_available_hardware
    Puppet.notice("\nServer Profile Template Available Hardware\n")
    pretty get_single_resource_instance.available_hardware
  end

  # Creates a new server profile based on the current template
  def set_new_profile
    # lets the SDK set a default name in case the user has not declared one
    if @data['serverProfileName']
      sp_name = @data.delete('serverProfileName')
      get_single_resource_instance.new_profile(sp_name).create
    else
      get_single_resource_instance.new_profile.create
    end
  end

  # Needs the attr connectionName
  def remove_connection
    raise('There are no connections settings in the manifest.') unless @data['connections']
    spt = get_single_resource_instance
    @data['connections'].each do |con|
      network = objectfromstring(con['type']).find_by(@client, name: con['name']).first
      spt.remove_connection(network)
    end
  end

  # Needs the attr network name, type and its options (optional)
  # def set_connection
  #   raise('There are no connections settings in the manifest.') unless @connections
  #   spt = get_single_resource_instance
  #   @connections.each do |con|
  #     # options = {}
  #     # options = con['options'] if con['options']
  #     # network = objectfromstring(con['type']).find_by(@client, name: con['name']).first
  #     # puts spt.methods
  #     # spt.add_connection(network)
  #     # function_type = con.delete('functionType')
  #     # name = con.delete('name')
  #     connectiontype = case con['functionType']
  #                       when 'Ethernet' then 'EthernetNetwork'
  #                       when 'FibreChannel' then 'FC'
  #                      end
  #     network = objectfromstring(connectiontype).find_by(@client, name: con['name']).first
  #     spt.add_connection(network, con)
  #   end
  # end

  # Needs the firmware driver name and its options
  def set_firmware_driver
    raise('There are no firmware driver settings in the manifest.') unless @data['firmwareDriver']
    firmware = @data['firmwareDriver']
    options = if firmware['options']
                firmware['options']
              else
                {}
              end
    fd = OneviewSDK::FirmwareDriver.find_by(@client, name: firmware['name']).first
    get_single_resource_instance.set_firmware_driver(fd, options)
  end

  # Needs the enclosure group name
  def set_enclosure_group
    raise('There are no enclosure group settings in the manifest.') unless @data['enclosureGroup']
    eg = OneviewSDK::EnclosureGroup.find_by(@client, name: @data['enclosureGroup']).first
    get_single_resource_instance.set_enclosure_group(eg)
  end

  # Needs the server hardware type name
  def set_server_hardware_type
    raise('There are no server hardware type settings in the manifest.') unless @data['serverHardwareType']
    sht = OneviewSDK::ServerHardwareType.find_by(@client, name: @data['serverHardwareType']).first
    get_single_resource_instance.set_server_hardware_type(sht)
  end

  def variable_assignments
    @connections = @data.delete('connections')
  end
end
