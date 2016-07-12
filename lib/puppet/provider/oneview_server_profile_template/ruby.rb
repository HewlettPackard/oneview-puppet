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
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'server_profile_template'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_server_profile_template).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
  end

  def exists?
    return true unless resource['data']
    data = data_parse
    spt = OneviewSDK::ServerProfileTemplate.new(@client, name: data['name'])
    # checking for updates once the state is present
    if spt.retrieve! && resource['ensure'] == :present
      resource_update(data, OneviewSDK::ServerProfileTemplate)
    end
    spt.exists?
  end

  def create
    data = data_parse
    spt = OneviewSDK::ServerProfileTemplate.new(@client, data)
    spt.create
  end

  def destroy
    spt = get_spt
    true if spt.delete
  end

  def found
    spt = OneviewSDK::ServerProfileTemplate.find_by(@client, data_parse)
    unless spt.first
      Puppet.warning("\n\nNo Server Profile Templates with the specified data were"\
      " found the Oneview Appliance\n")
      return false
    end
      Puppet.notice("\n\nFound Server Profile Template"\
      " #{spt.first.data['name']} (URI: #{spt.first.data['uri']}) in Oneview Appliance\n")
      true
  end

  def get_server_profile_templates
    Puppet.notice("\n\nServer Profile Templates\n")
    data = data_parse if resource['data']
    # in case there is no data, it sends an empty hash
    data = {} unless resource['data']
    spt = OneviewSDK::ServerProfileTemplate.find_by(@client, data)
    if spt.empty?
      Puppet.warning("\n\nNo Server Profile Templates with the specified data were"\
      " found on the Oneview Appliance\n")
      return false
    end
    spt.each do |item|
      Puppet.notice("\n\nName: #{item['name']}\n URI: #{item['uri']}\n\n")
    end
    true
  end

  def get_available_hardware
    spt = get_spt('Server Profile Templates Available Hardware')
    Puppet.notice(spt.available_hardware) unless spt.available_hardware.empty?
  end

  # Creates and returns a new server profile based on the current template
  def set_new_profile
    spt = get_spt('New Server Profile From Template')
    sp_name = "Server Profile from #{spt['name']}"
    sp_name = data_parse['serverProfileName'] if data_parse['serverProfileName']
    sp = spt.new_profile(sp_name)
    if sp.create
      Puppet.notice('A new Server Profile has been successfully created.')
      true
    else
      Puppet.warning('The Server profile could not be created.')
      false
    end
  end

  # Needs the attr connectionName
  def remove_connection
    data = data_parse
    unless data['connections']
      Puppet.warning('There are no connections settings in the manifest.')
      return false
    end
    connections = data['connections']
    spt = get_spt('Server Profile Templates Remove Connections')
    connections.each do |con|
      name = con['name']
      type = con['type']
      networkType = objectfromstring(type)
      network = networkType.new(@client, name: name)
      true if spt.remove_connection(network)
    end
  end

  # Needs the attr network name, type and its options
  def set_connection
    data = data_parse
    unless data['connections']
      Puppet.warning('There are no connections settings in the manifest.')
      return false
    end
    connections = data['connections']
    spt = get_spt('Server Profile Templates Set Connections')
    connections.each do |con|
      name = con['name']
      type = con['type']
      options = {}
      options = con['options'] if con['options']
      networkType = objectfromstring(type)
      network = networkType.new(@client, name: name)
      true if spt.add_connection(network, options)
    end
  end

  # Needs the firmware driver name and its options
  def set_firmware_driver
    spt = get_spt('Server Profile Templates Set Firmware Driver')
    data = data_parse
    unless data['firmwareDriver']
      Puppet.warning('There are no firmware drivers in the manifest.')
      return false
    end
    firmware = data['firmwareDriver']
    options = []
    options = firmware['options'] if firmware['options']
    fd = OneviewSDK::FirmwareDriver.new(@client, name: firmware['name'])
    fd.retrieve!
    true if spt.set_firmware_driver(fd, options)
  end

  # Needs the enclosure group name
  def set_enclosure_group
    spt = get_spt('Server Profile Templates Set Enclosure Group')
    data = data_parse
    unless data['enclosureGroup']
      Puppet.warning('There are no enclosure groups in the manifest.')
      return false
    end
    eg = OneviewSDK::EnclosureGroup.new(@client, name: data['enclosureGroup'])
    eg.retrieve!
    true if spt.set_enclosure_group(eg)
  end

  # Needs the server hardware type name
  def set_server_hardware_type
    spt = get_spt('Server Profile Templates Set Server Hardware Type')
    data = data_parse
    unless data['serverHardwareType']
      Puppet.warning('There are no server hardware types in the manifest.')
      return false
    end
    sht = OneviewSDK::ServerHardwareType.new(@client, name: data['serverHardwareType'])
    sht.retrieve!
    true if spt.set_server_hardware_type(sht)
  end
end
