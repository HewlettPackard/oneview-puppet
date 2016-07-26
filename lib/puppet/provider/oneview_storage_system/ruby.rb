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
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'storage_system'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_storage_system).provide(:ruby) do

  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::StorageSystem.get_all(@client)
    matches.collect do |line|
      # Puppet.notice("Storage System: #{line['name']}, URI: #{line['uri']}")
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
    unless state == 'present'
      storage_system = OneviewSDK::StorageSystem.new(@client, credentials: resource['data']['credentials'])
      return storage_system.retrieve!
    end
    if state == 'present'
      storage_system = OneviewSDK::StorageSystem.new(@client, credentials: resource['data']['credentials'])
      Puppet.notice("#{resource} '#{resource['data']}' located in Oneview Appliance")
      storage_system_update(resource['data'], storage_system, resource)
      return storage_system.retrieve!
    end
    @property_hash[:ensure] == :present
  end

  def create
    data = data_parse(resource['data'])
    data.delete('new_name') if data['new_name']
    storage_system = OneviewSDK::StorageSystem.new(@client, data)
    storage_system.add
    @property_hash[:ensure] = :present
    @property_hash[:data] = data
  end

  def destroy
    storage_system = OneviewSDK::StorageSystem.new(@client, credentials: resource['data']['credentials'])
    storage_system.remove if storage_system.retrieve!
    @property_hash.clear
  end

  def found
    # Searches storage systems with data matching the manifest data
    data = data_parse(resource['data'])
    data.delete('connectionTemplateUri') if data['connectionTemplateUri'] == nil
    matches = OneviewSDK::StorageSystem.find_by(@client, data)
    # If matches are found, iterate through them and notify. Else just notify.
    unless matches.empty?
       matches.each do |storage_system|
         Puppet.notice ( "\n\n Found matching storage system #{storage_system['name']} "+
         "(URI: #{storage_system['uri']}) on Oneview Appliance\n" )
      end
      true
    else
      Puppet.notice("\n\n No storage systems with the specified data were found on "+
      "the Oneview Appliance\n")
      false
    end
  end

  def get_storage_pools
    data = data_parse(resource['data'])
    storage_system = OneviewSDK::StorageSystem.new(@client, data)
    if storage_system.retrieve!
      puts "\nStorage System #{storage_system['name']} environmental configuration:\n"
      pretty storage_system.get_storage_pools
    end
    puts "\nStorage System #{storage_system['name']} does not exist\n" unless storage_system.retrieve!
    return storage_system.retrieve!
  end

  def get_managed_ports
      data = data_parse(resource['data'])
      # Verify if the ports parameter has been set or if we'll use nil
      ports = data['ports'] ? data['ports'] : nil
      data.delete('ports') if data['ports']
      storage_system = OneviewSDK::StorageSystem.new(@client, data)
      puts "\nStorage system #{storage_system['name']} does not exist.\n" unless storage_system.retrieve!
      if storage_system.retrieve!
        puts "\nRetrieving managed ports from storage system #{storage_system['name']}... \n"
        pretty storage_system.get_managed_ports(ports) if ports
        pretty storage_system.get_managed_ports unless ports
      end
      return storage_system.retrieve!
  end

  def get_host_types
    data = data_parse(resource['data'])
    # Verify that the storage system exists
    storage_system = OneviewSDK::StorageSystem.new(@client, data)
    puts "\nStorage system #{storage_system['name']} does not exist\n" unless storage_system.retrieve!
    if storage_system.retrieve!
      puts "\nRetrieving host types data for storage system '#{storage_system['name']}'...\n"
      pretty OneviewSDK::StorageSystem.get_host_types(@client)
    end
    return storage_system.retrieve!
  end

end
