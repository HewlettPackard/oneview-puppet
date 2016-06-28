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
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'volume'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_volume).provide(:ruby) do

  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::Volume.get_all(@client)
    matches.collect do |line|
      # Puppet.notice("Volume: #{line['name']}, URI: #{line['uri']}")
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
    # Verify if data is set for resources that need it, else fail
    unless resource['data'] || (state == 'found' || state == 'get_attachable_volumes' || state == 'get_extra_managed_volume_paths')
      fail("A 'data' Hash is required for the present operation")
    end
    unless state == 'present'
      # If no data hash is provided, create empty hash
      resource['data'] = Hash.new if resource['data'] == nil
      volume = OneviewSDK::Volume.find_by(@client, resource['data'])
      return volume
    end
    if state == 'present'
      fail("A 'name' parameter is required inside data for the present operation") unless resource['data']['name']
      volume = OneviewSDK::Volume.new(@client, name: resource['data']['name'])
      Puppet.notice("#{resource} '#{resource['data']['name']}' located in Oneview Appliance") if volume.retrieve!
      # volume_update(resource['data'], volume, resource)
      return volume.retrieve!
    end
    @property_hash[:ensure] == :present
  end

  def create
    data = data_parse(resource['data'])
    data.delete('new_name') if data['new_name']
    # Additional logic so that the storage IP can be provided instead of the rest uri for the pool
    if data['provisioningParameters']['storageSystemIp']
      # Grabs storage ip and removes it from the hash
      storage_system_ip = data['provisioningParameters']['storageSystemIp']
      data['provisioningParameters'].delete('storageSystemIp')
      # Finds the storage system through the ip
      storage_system = OneviewSDK::StorageSystem.new(@client, credentials: { ip_hostname: storage_system_ip })
      storage_system.retrieve!
      # Finds the pools associated with that storage ip and selects the first one
      pools = OneviewSDK::StoragePool.find_by(@client, storageSystemUri: storage_system[:uri])
      fail 'ERROR: No storage pools found attached to the provided storage system' if pools.empty?
      storage_pool = pools.first
      # Adds the first storage pool found to the data hash
      data['provisioningParameters']['storagePoolUri'] = storage_pool['uri']
    end
    # Creates the volume
    volume = OneviewSDK::Volume.new(@client, data)
    volume.create
    @property_hash[:ensure] = :present
    @property_hash[:data] = data
  end

  def destroy
    volume = OneviewSDK::Volume.new(@client, name: resource['data']['name'])
    volume.delete if volume.retrieve!
    @property_hash.clear
  end

  def found
    # Searches Volumes with data matching the manifest data
    data = data_parse(resource['data'])
    matches = OneviewSDK::Volume.find_by(@client, data)
    # If matches are found, iterate through them and notify. Else just notify.
    unless matches.empty?
       matches.each do |volume|
         Puppet.notice ( "\n\n Found matching volume #{volume['name']} "+
         "(URI: #{volume['uri']}) on Oneview Appliance\n" )
      end
      true
    else
      Puppet.notice("\n\n No volumes with the specified data were found on "+
      "the Oneview Appliance\n")
      false
    end
  end

  def get_attachable_volumes
    Puppet.notice("\n Getting attachable volumes...\n")
    Puppet.notice("\n Displaying list of attachable volumes bellow:\n")
    pretty OneviewSDK::Volume.get_attachable_volumes(@client)
    Puppet.notice("\n <End of the list of attachable volumes>\n")
    true
  end

  def get_extra_managed_volume_paths
    Puppet.notice("\n Getting extra managed volume paths...\n")
    Puppet.notice("\n Displaying list of extra managed volume paths bellow:\n")
    pretty OneviewSDK::Volume.get_extra_managed_volume_paths(@client)
    Puppet.notice("\n <End of the list of attachable volumes>\n")
    true
  end

  def repair
      data = data_parse(resource['data'])
      volume = OneviewSDK::Volume.new(@client, data)
      puts "\nVolume #{volume['name']} does not exist.\n" unless volume.retrieve!
      if volume.retrieve!
        puts "\n Removing extra presentations from specified volume #{volume['name']}... \n"
        volume.repair
      end
      return volume.retrieve!
  end

  def create_snapshot
      data = data_parse(resource['data'])
      # Verify if the ports parameter has been set or if we'll use nil
      volume = OneviewSDK::Volume.new(@client, name: resource['data']['name'])
      puts "\nVolume #{volume['name']} does not exist.\n" unless volume.retrieve!
      if volume.retrieve!
        puts "\nCreating snapshot on Volume #{volume['name']}... \n"
        volume.create_snapshot(data['snapshotParameters'])
      end
      return volume.retrieve!
  end

  def delete_snapshot
      data = data_parse(resource['data'])
      # Verify if the ports parameter has been set or if we'll use nil
      volume = OneviewSDK::Volume.new(@client, name: resource['data']['name'])
      puts "\nVolume #{volume['name']} does not exist.\n" unless volume.retrieve!
      if volume.retrieve!
        puts "\nDeleting snapshot on Volume #{volume['name']}... \n"
        volume.delete_snapshot(data['snapshotParameters']['name'])
      end
      return volume.retrieve!
  end

  def get_snapshot
      data = data_parse(resource['data'])
      # Verify if the ports parameter has been set or if we'll use nil
      volume = OneviewSDK::Volume.new(@client, name: data['name'])
      puts "\nVolume #{volume['name']} does not exist.\n" unless volume.retrieve!
      if volume.retrieve!
        if data['snapshotParameters']
          # Checks that name exists within snapshotParameters
          fail ("A snapshot Parameter 'name' is required for this operation") unless data['snapshotParameters']['name']
          puts "\n Getting snapshot #{data['snapshotParameters']['name']} from Volume #{volume['name']}... \n"
          pretty volume.get_snapshot(data['snapshotParameters']['name'])
        end
        unless data['snapshotParameters']
          puts "\n Getting all snapshots from Volume #{volume['name']}... \n"
          pretty volume.get_snapshots
        end
      end


      return volume.retrieve!
  end


end
