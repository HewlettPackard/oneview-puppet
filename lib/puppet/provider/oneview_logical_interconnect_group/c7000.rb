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

require_relative '../oneview_resource'

Puppet::Type::Oneview_logical_interconnect_group.provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Logical Enclosures using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def exists?
    super
    # Assignments and helpers
    @interconnects = @data.delete('interconnects')
    uri_getters('internalNetworkUris')
    uri_getters('uplinkSets')
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    new_name = @data.delete('new_name')
    lig = @resourcetype.new(@client, @data)
    add_interconnects(lig) if @interconnects
    @data['new_name'] = new_name if new_name
    return true if resource_update(@data, @resourcetype)
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
    pretty get_single_resource_instance.get_default_settings
    true
  end

  def add_interconnects(lig)
    @interconnects.each do |item|
      lig.add_interconnect(item['bay'].to_i, item['type'])
    end
  end

  # Grabs the uplink sets uris
  def uri_getters(field)
    return unless @data[field]
    list = []
    @data[field].each do |item|
      next if item.to_s[0..6].include?('/rest/')
      set = if field.eql?('uplinkSets')
              OneviewSDK::UplinkSet.find_by(@client, name: item)
            else
              OneviewSDK::EthernetNetwork.find_by(@client, name: item)
            end
      raise("The resource #{item} does not exist.") unless set.first
      list.push(set.first['uri'])
    end
    @data[field] = list
  end
end
