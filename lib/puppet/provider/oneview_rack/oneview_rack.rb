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

Puppet::Type.type(:oneview_rack).provide(:oneview_rack) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::Rack
    # Initializes the data so it is parsed only on exists and accessible throughout the methods
    # This is not set here due to the 'resources' variable not being accessible in initialize
    @data = {}
    @rack_resource = {}
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::Rack.get_all(@client)
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
    pretty @data
    empty_data_check([:found, :absent])
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    return true if resource_update(@data, @resourcetype)
    @resourcetype.new(@client, @data).add
    @property_hash[:ensure] = :present
    @property_hash[:data] = @data
    true
  end

  def destroy
    racks = @resourcetype.find_by(@client, @data)
    raise 'No racks matching the specified data were found' if racks.empty?
    racks.each do |rack|
      Puppet.notice "\n\n Removing rack named: #{rack['name']}, with uri: #{rack['uri']}\n"
      rack.remove
      @property_hash.clear
    end
  end

  def found
    find_resources
  end

  def get_device_topology
    pretty get_single_resource_instance.get_device_topology
    true
  end

  def add_rack_resource
    raise 'A "rackMounts" attribute is required within data with the options of the resource to be added' unless @data['rackMounts']
    rack_resources = @data.delete('rackMounts')
    rack = get_single_resource_instance
    rack_resources.each do |new_resources|
      uri = get_mount_uri(new_resources)
      rack.add_rack_resource(uri, new_resources)
    end
    rack.update
    @property_hash[:data] = rack.data
    true
  end

  def remove_rack_resource
    raise 'A "rackMounts" attribute is required within data with the options of the resource to be removed' unless @data['rackMounts']
    rack_resources = @data.delete('rackMounts')
    rack = get_single_resource_instance
    rack_resources.each do |new_resources|
      uri = get_mount_uri(new_resources)
      rack.remove_rack_resource(uri)
    end
    rack.update
    @property_hash[:data] = rack.data
    true
  end

  def get_mount_uri(new_resource)
    uri = {}
    uri['uri'] = new_resource.delete('uri') if new_resource['uri']
    uri['uri'] = new_resource.delete('mountUri') if new_resource['mountUri']
    uri
  end
end
