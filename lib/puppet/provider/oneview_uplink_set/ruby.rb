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

Puppet::Type.type(:oneview_uplink_set).provide(:ruby) do
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
          data: data
         )
    end
  end

  # TODO: eventually implement this prefetch method as it seems useful but requires an investigation into it
  # def self.prefetch(resources)
  #   packages = instances
  #   resources.keys.each do |name|
  #     if provider = packages.find { |pkg| pkg.name == name }
  #       resources[name].provider = provider
  #     end
  #   end
  # end

  def pretty(arg)
    return puts arg if arg.instance_of?(String)
    puts JSON.pretty_generate(arg)
  end

  # Provider methods

  def exists?
    state = resource['ensure'].to_s
    @data = data_parse
    parse_port_config_infos('exists?')
    # # TODO: This validation should be run on the "type" itself
    # # In case it is not, this part of the code should be enabled
    # # Verify if data is set for resources that need it, else fail
    # unless resource['data'] || (state == 'found')
    #   fail("A 'data' Hash is required for the present operation")
    # end
    uplink_set = if state == 'present'
                   # TODO: assure update works
                   resource_update(@data, @resourcetype)
                   @resourcetype.find_by(@client, name: @data['name'])
                 else
                   @resourcetype.find_by(@client, @data)
                 end
    # Puppet.notice("#{resource} '#{@data['name']}' located in Oneview Appliance") unless uplink_set.empty? || !@data['name']
    !uplink_set.empty?
  end

  def create
    uplink_set = @resourcetype.new(@client, @data)
    uri_setter(uplink_set)
    uplink_set.create
    @property_hash[:ensure] = :present
    @property_hash[:data] = @data
  end

  def destroy
    uplink_set = @resourcetype.find_by(@client, name: @data['name']).first
    if uplink_set
      uplink_set.delete
    else
      Puppet.notice("#{resource} '#{@data['name']}' not located in Oneview Appliance")
    end
    @property_hash.clear
  end

  def found
    # Searches UplinkSets with data matching the manifest data
    retrieved_resource = @resourcetype.find_by(@client, @data)
    # If resources are found, iterate through them and notify. Else just notify.
    if !retrieved_resource.empty?
      retrieved_resource.each do |uplink_set|
        Puppet.notice "\n\n Found matching Uplink Set #{uplink_set['name']} "\
        "(URI: #{uplink_set['uri']}) on Oneview Appliance\n"
      end
      true
    else
      Puppet.notice("\n\n No Uplink Sets with the specified data were found on "\
      "the Oneview Appliance\n")
      false
    end
  end

  def uri_setter(uplink_set)
    # Calls the sdk helper methods in case the user used the special parameters to set uris
    parse_network(uplink_set)
    parse_fc_network(uplink_set)
    parse_fcoe_network(uplink_set)
    parse_logical_interconnect(uplink_set)
    parse_port_config_infos('uri_setter', uplink_set)
  end

  def parse_network(uplink_set)
    if resource['network']
      network = OneviewSDK::EthernetNetwork.find_by(@client, name: resource['network']).first
      fail 'The specified network resource could not be found on the appliance' if network.nil?
      uplink_set.add_network(network)
    end
  end

  def parse_fc_network(uplink_set)
    if resource['fc_network']
      network = OneviewSDK::FCNetwork.find_by(@client, name: resource['fc_network']).first
      fail 'The specified fc network resource could not be found on the appliance' if network.nil?
      uplink_set.add_fcnetwork(network)
    end
  end

  def parse_fcoe_network(uplink_set)
    if resource['fcoe_network']
      network = OneviewSDK::FCoENetwork.find_by(@client, name: resource['fcoe_network']).first
      fail 'The specified fcoe network resource could not be found on the appliance' if network.nil?
      uplink_set.add_fcoenetwork(network)
    end
  end

  def parse_logical_interconnect(uplink_set)
    if resource['logical_interconnect']
      logint = OneviewSDK::LogicalInterconnect.find_by(@client, name: resource['logical_interconnect']).first
      fail 'The specified Logical Interconnect could not be found on the appliance' if logint.nil?
      uplink_set.set_logical_interconnect(logint)
    end
  end

  def parse_port_config_infos(method, uplink_set = '')
    if method == 'exists?'
      @port_config = @data['portConfigInfos']
      @data.delete('portConfigInfos')
    elsif method != 'exists?' && @port_config
      uplink_set.add_port_config(@port_config)
    end
  end

  # def uplink_update
  #   current_resource = @resourcetype.find_by(@client, name: @data['name']).first
  #   current_resource ? current_attributes = current_resource.data : return
  #   if @data['new_name']
  #     new_resource_name_used = @resourcetype.find_by(@client, name: @data['new_name']).first
  #     @data['name'] = @data['new_name'] unless new_resource_name_used
  #     @data.delete('new_name')
  #   end
  #   raw_merged_data = current_attributes.merge(data)
  #   updated_data = Hash[raw_merged_data.to_a - current_attributes.to_a]
  #   current_resource.update(updated_data) if updated_data.size > 0
  # end
end
