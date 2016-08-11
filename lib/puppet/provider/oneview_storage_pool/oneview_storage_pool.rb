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

Puppet::Type.type(:oneview_storage_pool).provide(:oneview_storage_pool) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::StoragePool
    # Initializes the data so it is parsed only on exists and accessible throughout the methods
    # This is not set here due to the 'resources' variable not being accessible in initialize
    @data = {}
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::StoragePool.find_by(@client, {})
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
    # Allows find_by to work in case poolName is declared, since find_by returns it as 'name'
    @data['name'] = @data.delete('poolName') if @data['poolName']
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    raise 'A "poolName" or "name" tag is required within data for this operation' unless @data['name']
    return unless setup_for_recreation
    # Changes name into poolName which is required only for creation
    @data['poolName'] = @data.delete('name') if @data['name']
    @resourcetype.new(@client, @data).add
    @property_hash[:ensure] = :present
    @property_hash[:data] = @data
    true
  end

  def destroy
    get_single_resource_instance.remove
    @property_hash.clear
    true
  end

  def found
    find_resources
  end

  def setup_for_recreation
    storage_pool = @resourcetype.find_by(@client, name: @data['name'])
    return true if storage_pool.empty?
    storage_pool.first.remove
    true
  end
end
