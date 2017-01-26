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

Puppet::Type::Oneview_sas_logical_interconnect_group.provide :synergy, parent: Puppet::OneviewResource do
  desc 'Provider for OneView SAS Logical Enclosures using the Synergy variant of the OneView API'

  confine true: login[:hardware_variant] == 'Synergy'

  mk_resource_methods

  def resource_name
    'SASLogicalInterconnectGroup'
  end

  def self.resource_name
    'SASLogicalInterconnectGroup'
  end

  def exists?
    super
    @interconnects = @data.delete('interconnects')
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

  def add_interconnects(lig)
    @interconnects.each do |item|
      lig.add_interconnect(item['bay'].to_i, item['type'])
    end
  end
end
