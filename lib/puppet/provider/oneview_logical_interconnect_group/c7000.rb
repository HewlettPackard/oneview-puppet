################################################################################
# (C) Copyright 2016-2021 Hewlett Packard Enterprise Development LP
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

require_relative '../oneview_resource'

Puppet::Type.type(:oneview_logical_interconnect_group).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Logical Enclosures using the C7000 variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def initialize(*args)
    super(*args)
    @uplink_sets = {}
    @interconnects = {}
    @internal_network_uris = {}
  end

  def exists?
    super
    # Assignments and helpers
    @interconnects = @data.delete('interconnects')
    @uplink_sets = @data.delete('uplinkSets')
    @internal_network_uris = @data.delete('internalNetworkUris')
    @data['uplinkSets'] = parse_uplink_sets if @uplink_sets
    @data['interconnectMapTemplate'] = parse_interconnects if @interconnects
    @data['internalNetworkUris'] = parse_internal_networks if @internal_network_uris
    @resource_type.find_by(@client, @data).any?
  end

  def create
    new_name = @data.delete('new_name')
    lig = @resource_type.new(@client, @data)
    @data['new_name'] = new_name if new_name
    return true if resource_update
    lig.create
    @property_hash[:data] = lig.data
    @property_hash[:ensure] = :present
  end

  def get_settings
    Puppet.notice("\n\nLogical Interconnect Group Settings\n")
    pretty get_single_resource_instance.get_settings
    true
  end

  def get_default_settings
    Puppet.notice("\n\nLogical Interconnect Group Default Settings\n")
    pretty @resource_type.get_default_settings(@client)
    true
  end

  # Helpers

  # Method to allow for names to be used instead of uris for the field internalNetworkUris
  def parse_internal_networks
    list = []
    @internal_network_uris.each do |item|
      next if item.to_s[0..6].include?('/rest/')
      net = OneviewSDK.resource_named(:EthernetNetwork, login[:api_version], login[:hardware_variant]).find_by(@client, name: item)
      raise("The resource #{item} does not exist.") unless net.first
      list.push(net.first['uri'])
    end
    list
  end

  # Method to allow for a compact syntax to be used for declaring interconnects inside the LIG
  def parse_interconnects
    lig = OneviewSDK.resource_named(:LogicalInterconnectGroup, login[:api_version], login[:hardware_variant]).new(@client, {})
    @interconnects.each do |item|
      lig.add_interconnect(item['bay'].to_i, item['type'])
    end
    lig['interconnectMapTemplate']
  end

  # Method to allow for a compact syntax to be used for creating LIG uplink sets
  def parse_uplink_sets
    api_version = login[:api_version]
    hardware_variant = login[:hardware_variant]
    lig = OneviewSDK.resource_named(:LogicalInterconnectGroup, api_version, hardware_variant).new(@client, {})
    @uplink_sets.each do |uplink_set_params|
      network_uris = uplink_set_params.delete('networkUris')
      uplink_ports = uplink_set_params.delete('uplink_ports')
      uplink_set = OneviewSDK.resource_named(:LIGUplinkSet, api_version, hardware_variant).new(@client, uplink_set_params)
      set_network(uplink_set, uplink_set_params['networkType'], network_uris) if network_uris
      set_uplink_ports(uplink_set, uplink_ports) if uplink_ports
      lig.add_uplink_set(uplink_set)
    end
    lig.data['uplinkSets']
  end

  # Method to allow using a name instead of uri for networks inside the UplinkSet
  def set_network(uplink_set, network_type, network_uris)
    net_type = network_type == 'Ethernet' ? :EthernetNetwork : :FCNetwork
    net_class = OneviewSDK.resource_named(net_type, login[:api_version], login[:hardware_variant])
    network_uris.each do |network_uri|
      # Added a block to handle network uris in an uplinkset
      if network_uri.to_s[0..6].include?('/rest/')
        net = net_class.new(@client, uri: network_uri)
        raise "Network in networkUris not found. Uri specified for the network: #{network_uri}" unless net.retrieve!
        uplink_set.add_network(net)
        next
      end
      net = net_class.new(@client, name: network_uri)
      raise "Network in networkUris not found. Name specified for the network: #{network_uri}" unless net.retrieve!
      uplink_set.add_network(net)
    end
    uplink_set
  end

  # Method to add the uplink bay & port to the LIGuplinkSet using helpers
  def set_uplink_ports(uplink_set, uplink_ports)
    uplink_ports.each do |uplink_port|
      uplink_port['enclosure_index'] ||= 1
      uplink_set.add_uplink(uplink_port['bay'], uplink_port['port'], uplink_port['type'], uplink_port['enclosure_index'])
    end
    uplink_set
  end
end
