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

Puppet::Type.type(:oneview_uplink_set).provide(:oneview_uplink_set) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::UplinkSet
    # Initializes the data so it is parsed only on exists and accessible throughout the methods
    # This is not set here due to the 'resources' variable not being accessible in initialize
    @data = {}
    @port_config
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::UplinkSet.get_all(@client)
    matches.collect do |line|
      name = line['name']
      data = line.inspect
      new(name: name,
          ensure: :present,
          data: data)
    end
  end

  # Provider methods
  def exists?
    @data = data_parse
    empty_data_check
    name_to_uris
    # Taking out portConfigInfos before the find_by since it is not returned
    @port_config = @data.delete('portConfigInfos')
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    uplink_set = @resourcetype.new(@client, @data)
    uplink_set.add_port_config(@port_config) if @port_config
    uplink_set.create
    @property_hash[:ensure] = :present
    @property_hash[:data] = @data
    true
  end

  def destroy
    get_single_resource_instance.delete
    @property_hash.clear
    true
  end

  def found
    find_resources
  end

  # Calls the sdk helper methods in case the user used the resource names to set uris
  def name_to_uris
    uri_set('networkUris', OneviewSDK::EthernetNetwork)
    uri_set('fcNetworkUris', OneviewSDK::FCNetwork)
    uri_set('fcoeNetworkUris', OneviewSDK::FCoENetwork)
  end

  def uri_set(tag, type)
    network_uris = @data.delete(tag)
    return unless network_uris
    network_uris.each_with_index do |network_name, index|
      next if network_name.to_s[0..6].include?('/rest/')
      network = type.find_by(@client, name: network_name).first
      raise "No #{type.to_s.split('::')[1]}s with the name #{network_name} have been found on the appliance" unless network
      network_uris[index] = network['uri']
    end
    @data[tag] = network_uris
  end
end
