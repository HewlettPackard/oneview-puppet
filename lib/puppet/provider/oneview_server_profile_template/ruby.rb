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
    return true if !resource['data']
    data = data_parse.clone
    spt = OneviewSDK::ServerProfileTemplate.new(@client, name: data['name'])
    # checking for updates once the state is not absent
    if spt.retrieve! && resource['ensure'] != 'absent'
      resource_update(spt_parse(data_parse), OneviewSDK::ServerProfileTemplate)
    end
    spt.retrieve!
  end

  def create
    data = spt_parse(data_parse)
    spt = OneviewSDK::ServerProfileTemplate.new(@client, data)
    spt.create!
  end

  def destroy
    data = data_parse
    spt = OneviewSDK::ServerProfileTemplate.new(@client, name: data['name'])
    spt.retrieve!
    spt.delete
  end

  def found
    data = data_parse
    spt = OneviewSDK::ServerProfileTemplate.new(@client, name: data['name'])
    if spt.retrieve!
      Puppet.notice("\n\nFound Server Profile Template"\
      " #{spt['name']} (URI: #{spt['uri']}) in Oneview Appliance\n")
      true
    else
      Puppet.notice("\n\nNo Server Profile Templates with the specified data were"\
      " found the Oneview Appliance\n")
      false
    end
  end

  def get_server_profile_templates
    Puppet.notice("\n\nServer Profile Templates\n")
    data = spt_parse(data_parse) if resource['data']
    data = {} if !resource['data']
    spt = OneviewSDK::ServerProfileTemplate.find_by(@client, data)
    spt.each do |item|
      Puppet.notice("\n\nName: #{item['name']}\n URI: #{item['uri']}\n\n")
    end
    if spt.empty?
      Puppet.notice("\n\nNo Server Profile Templates with the specified data were"+
      " found on the Oneview Appliance\n")
      return false
    end
    true
  end

  # These endpoints only work with the new version of the SDK installed,
  # and will be uncommented once it has been released
  #
  # def set_new_profile
  #   Puppet.notice("\n\nNew Server Profile From Template\n")
  #   data = spt_parse(data_parse)
  #   spt = OneviewSDK::ServerProfileTemplate.new(@client, data)
  #   unless spt.retrieve!
  #     Puppet.notice("\n\nNo Server Profile Templates with the specified data were"+
  #     " found on the Oneview Appliance\n")
  #     return false
  #   end
  #   spt.new_profile
  # end
  #
  # def get_available_hardware
  #   Puppet.notice("\n\nServer Profile Templates Available Hardware\n")
  #   data = spt_parse(data_parse)
  #   spt = OneviewSDK::ServerProfileTemplate.new(@client, data)
  #   spt.retrieve!
  #   false unless spt.available_hardware.empty?
  # end
  #
  # Needs the attr connectionName
  # def remove_connection
  #   Puppet.notice("\n\nServer Profile Templates Remove Connection\n")
  #   data = spt_parse(data_parse)
  #   spt = OneviewSDK::ServerProfileTemplate.new(@client, name: data['name'])
  #   spt.retrieve!
  #   true if spt.remove_connection(data['connectionName'])
  # end
  #
  # Needs the attr network name, type and its options
  # def set_connection
  #   Puppet.notice("\n\nServer Profile Templates Set Connection\n")
  #   data = spt_parse(data_parse)
  #   spt = OneviewSDK::ServerProfileTemplate.new(@client, name: data['name'])
  #   spt.retrieve!
  #   networkType = Object.const_get(data['network']['type'])
  #   network = networkType.new(@client, name: data['network']['name'])
  #   network.retrieve!
  #   true if spt.add_connection(network, data['network']['options'])
  # end
  #
  # Needs the firmware driver name and its options
  # def set_firmware_driver
  #   Puppet.notice("\n\nServer Profile Templates Set Firmware Driver\n")
  #   data = spt_parse(data_parse)
  #   spt = OneviewSDK::ServerProfileTemplate.new(@client, name: data['name'])
  #   spt.retrieve!
  #   firmware = OneviewSDK::FirmwareDriver.new(@client, name: data['firmwareDriver']['name'])
  #   firmware.retrieve!
  #   true if spt.set_firmware_driver(firmware, data['firmwareDriver']['options'])
  # end
  #
  # Needs the enclosure group name
  # def set_enclosure_group
  #   Puppet.notice("\n\nServer Profile Templates Set Enclosure Group\n")
  #   data = spt_parse(data_parse)
  #   spt = OneviewSDK::ServerProfileTemplate.new(@client, name: data['name'])
  #   spt.retrieve!
  #   eg = OneviewSDK::EnclosureGroup.new(@client, name: data['enclosureGroup']['name'])
  #   eg.retrieve!
  #   true if spt.set_enclosure_group(eg)
  # end
  #
  # Needs the server hardware type name
  # def set_server_hardware_type
  #   Puppet.notice("\n\nServer Profile Templates Set Server Hardware Type\n")
  #   data = spt_parse(data_parse)
  #   spt = OneviewSDK::ServerProfileTemplate.new(@client, name: data['name'])
  #   spt.retrieve!
  #   sht = OneviewSDK::ServerHardwareType.new(@client, name: data['serverHardwareType']['name'])
  #   sht.retrieve!
  #   true if spt.set_server_hardware_type(sht)
  # end

end
