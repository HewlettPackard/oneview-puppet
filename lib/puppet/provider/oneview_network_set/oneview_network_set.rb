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

Puppet::Type.type(:oneview_network_set).provide(:oneview_network_set) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::NetworkSet
    @ethernet = OneviewSDK::EthernetNetwork
    @data = {}
  end

  def exists?
    # assignments and deletions from @data
    @data = data_parse
    variable_assignments
    empty_data_check([:found, :get_without_ethernet])
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    return true if resource_update(@data, @resourcetype)
    ns = @resourcetype.new(@client, @data)
    set_native_network_helper(ns) if @native_network
    add_ethernet_network_helper(ns) if @ethernet_networks
    ns.create
  end

  def destroy
    get_single_resource_instance.delete
  end

  def found
    find_resources
  end

  def get_without_ethernet
    Puppet.notice("\n\nNetwork Set Without Ethernet\n")
    if @data.empty?
      list = @resourcetype.get_without_ethernet(@client)
      raise('There is no Network Set without ethernet in the Oneview appliance.') if list.empty?
      list.each { |item| pretty item }
    else
      item = get_single_resource_instance.get_without_ethernet
      raise('There is no Network Set without ethernet in the Oneview appliance.') unless item
      pretty item
    end
    true
  end

  def set_native_network
    raise('You need to specify a network in order to perform this action.') unless @native_network
    ns = get_single_resource_instance
    set_native_network_helper(ns)
    ns.update
  end

  def add_ethernet_network
    raise('You need to specify at least one network in order to perform this action.') unless @ethernet_networks
    ns = get_single_resource_instance
    add_ethernet_network_helper(ns)
    ns.update
  end

  def remove_ethernet_network
    raise('You need to specify at least one network in order to perform this action.') unless @ethernet_networks
    ns = get_single_resource_instance
    @ethernet_networks.each do |net|
      ethernet = @ethernet.find_by(@client, name: net)
      raise('The network declared in the manifest does not exists in the Appliance.') unless ethernet.first
      ns.remove_ethernet_network(ethernet.first)
    end
    ns.update
  end

  # Helper methods

  def add_ethernet_network_helper(ns)
    @ethernet_networks.each do |net|
      ethernet = @ethernet.find_by(@client, name: net)
      raise('The network declared in the manifest does not exists in the Appliance.') unless ethernet.first
      ns.add_ethernet_network(ethernet.first)
    end
  end

  def set_native_network_helper(ns)
    ethernet = @ethernet.find_by(@client, name: @native_network)
    raise('The network declared in the manifest does not exists in the Appliance.') unless ethernet.first
    ns.set_native_network(ethernet.first)
  end

  def variable_assignments
    @ethernet_networks = @data.delete('ethernetNetworks') if @data['ethernetNetworks']
    @native_network = @data.delete('nativeNetwork') if @data['nativeNetwork']
  end
end
