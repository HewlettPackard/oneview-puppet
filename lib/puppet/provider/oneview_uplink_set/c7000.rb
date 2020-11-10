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

require_relative '../oneview_resource'
require 'oneview-sdk'

Puppet::Type.type(:oneview_uplink_set).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Uplink Sets using the C7000 variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  # Provider methods
  def exists?
    @data = resource['data']
    set_li_uri
    set_network_uris
    prepare_environment
    name_to_uris
    # Taking out portConfigInfos before the find_by since it is not returned
    @port_config = @data.delete('portConfigInfos')
    !@resource_type.find_by(@client, @data).empty?
  end

  def create
    new_name = @data.delete('new_name')
    uplink_set = @resource_type.new(@client, @data)
    @data['new_name'] = new_name if new_name
    return true if resource_update
    uplink_set.add_port_config(@port_config[0], @port_config[1], @port_config[2]) if @port_config
    uplink_set.create
    @property_hash[:ensure] = :present
    @property_hash[:data] = uplink_set.data
    true
  end

  # Helper method to transform names into uris
  def name_to_uris
    uri_set('networkUris', OneviewSDK::EthernetNetwork)
    uri_set('fcNetworkUris', OneviewSDK::FCNetwork)
    uri_set('fcoeNetworkUris', OneviewSDK::FCoENetwork)
  end

  def set_network_uris
    return unless @data['networkUris'] && @data['networkUris'].present?
    network_class = OneviewSDK.resource_named('EthernetNetwork', @client.api_version)
    options = {
      vlanId:  '200',
      purpose:  'General',
      name:  'EtherNetwork_1',
      ethernetNetworkType: 'Tagged',
      smartLink:  false,
      privateNetwork:  false
    }
    network_one = network_class.new(@client, options)
    network_one.create!

    options['name'] = 'EtherNetwork_2'
    options['vlanId'] = '201'
    network_two = network_class.new(@client, options)
    network_two.create!
    @data['networkUris'] = [network_one['name'], network_two['name']]
  end

  def set_li_uri
    return unless resource['data']['logicalInterconnectUri'] && resource['data']['logicalInterconnectUri'].present?
    li_class = OneviewSDK.resource_named('LogicalInterconnect', @client.api_version)
    resource['data']['logicalInterconnectUri'] = li_class.get_all(@client).first['name']
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
