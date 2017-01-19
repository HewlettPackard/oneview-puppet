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

require_relative '../login'
require_relative '../common'
require 'oneview-sdk'

Puppet::Type.type(:oneview_storage_system).provide(:oneview_storage_system) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::StorageSystem
    # Initializes the data so it is parsed only on exists and accessible throughout the methods
    # This is not set here due to the 'resources' variable not being accessible in initialize
    @data = {}
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::StorageSystem.find_by(@client, {})
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
    empty_data_check([:found, :get_host_types])
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
    storage_system = get_single_resource_instance
    storage_system.remove
    @property_hash.clear
    true
  end

  def found
    find_resources
  end

  def get_storage_pools
    storage_system = get_single_resource_instance
    Puppet.notice "\nStorage System #{storage_system['name']} storage pools:\n"
    pretty storage_system.get_storage_pools
    true
  end

  def get_managed_ports
    ports ||= @data.delete('ports')
    storage_system = get_single_resource_instance
    Puppet.notice "\nRetrieving managed ports from storage system #{storage_system['name']}...\n"
    pretty storage_system.get_managed_ports(ports)
    true
  end

  def get_host_types
    pretty OneviewSDK::StorageSystem.get_host_types(@client)
    true
  end
end
