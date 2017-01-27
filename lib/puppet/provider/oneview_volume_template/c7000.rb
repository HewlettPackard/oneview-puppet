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

Puppet::Type::Oneview_volume_template.provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Volume Template using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def exists?
    @data = data_parse
    empty_data_check
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    return true if resource_update(@data, @resourcetype)
    @resourcetype.new(@client, @data).create
    @property_hash[:ensure] = :present
    @property_hash[:data] = @data
    true
  end

  def destroy
    get_single_resource_instance.delete
    @property_hash.clear
    true
  end

  def found
    find_resources
  end

  def get_connectable_volume_templates
    query_parameters = @data.delete('query_parameters') || {}
    pretty get_single_resource_instance.get_connectable_volume_templates(query_parameters)
    true
  end

  def resource_name
    'VolumeTemplate'
  end

  def self.resource_name
    'VolumeTemplate'
  end
end
