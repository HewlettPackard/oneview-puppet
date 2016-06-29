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
# require File.expand_path(File.join(File.dirname(__FILE__), '..', 'storage_pool'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_storage_pool).provide(:ruby) do

  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::StoragePool.get_all(@client)
    matches.collect do |line|
      name = line['name']
      data = line.inspect
      new(:name   => name,
          :ensure => :present,
          :data   => data
          )
    end
  end

  def self.prefetch(resources)
    packages = instances
    resources.keys.each do |name|
      if provider = packages.find{ |pkg| pkg.name == name }
        resources[name].provider = provider
      end
    end
  end

  def pretty(arg)
    return puts arg if arg.instance_of?(String)
    puts JSON.pretty_generate(arg)
  end

  # Provider methods

  def exists?
    state = resource['ensure'].to_s
    resource['data']['poolName'] = resource['data']['name'] if resource['data']['name']
    # Verify if data is set for resources that need it, else fail
    unless resource['data'] || (state == 'found')
      fail("A 'data' Hash is required for the present operation")
    end
    unless state == 'present'
      # If no data hash is provided, create empty hash
      resource['data'] = Hash.new if resource['data'] == nil
      storage_pool = OneviewSDK::StoragePool.find_by(@client, resource['data'])
      return storage_pool
    end
    if state == 'present'
      storage_pool = OneviewSDK::StoragePool.new(@client, name: resource['data']['poolName'])
      Puppet.notice("#{resource} '#{resource['data']['poolName']}' located in Oneview Appliance") if storage_pool.retrieve!
      return storage_pool.retrieve!
    end
    @property_hash[:ensure] == :present
  end

  def create
    data = data_parse(resource['data'])
    # Creates the storage pool
    storage_pool = OneviewSDK::StoragePool.new(@client, data)
    storage_pool.create
    @property_hash[:ensure] = :present
    @property_hash[:data] = data
  end

  def destroy
    # Here both name and poolName are accepted as inputs
    storage_pool = OneviewSDK::StoragePool.new(@client, name: resource['data']['poolName']) if resource['data']['poolName']
    storage_pool = OneviewSDK::StoragePool.new(@client, name: resource['data']['name']) if resource['data']['name']
    storage_pool.delete if storage_pool.retrieve!
    @property_hash.clear
  end

  def found
    # Searches StoragePools with data matching the manifest data
    data = data_parse(resource['data'])
    matches = OneviewSDK::StoragePool.find_by(@client, data)
    # If matches are found, iterate through them and notify. Else just notify.
    unless matches.empty?
       matches.each do |storage_pool|
         Puppet.notice ( "\n\n Found matching storage pool #{storage_pool['poolName']} "+
         "(URI: #{storage_pool['uri']}) on Oneview Appliance\n" )
      end
      true
    else
      Puppet.notice("\n\n No storage pools with the specified data were found on "+
      "the Oneview Appliance\n")
      false
    end
  end

end
