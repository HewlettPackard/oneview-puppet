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

Puppet::Type.type(:oneview_enclosure_group).provide(:oneview_enclosure_group) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::EnclosureGroup
    @data = {}
  end

  def exists?
    @data = data_parse
    empty_data_check
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    return true if resource_update(@data, @resourcetype)
    @resourcetype.new(@client, enclosure_group_parse(@data)).create
  end

  def destroy
    get_single_resource_instance.delete
  end

  def found
    find_resources
  end

  def get_script
    Puppet.notice("Enclosure Group's current script: \n#{get_single_resource_instance.get_script}\n")
  end

  def set_script
    script = @data.delete('script') if @data['script']
    raise("\nThe 'script' field is required in data hash to run the set_script action.") unless script
    get_single_resource_instance.set_script(script)
    Puppet.notice("Enclosure Group script set to:\n#{script}\n")
  end

  def enclosure_group_parse(data)
    data['interconnectBayMappingCount'] = Integer(data['interconnectBayMappingCount']) if data['interconnectBayMappingCount']
    if data['interconnectBayMappings']
      data['interconnectBayMappings'].each do |mapping_attr|
        mapping_attr['interconnectBay'] = mapping_attr['interconnectBay'].to_i
        mapping_attr['logicalInterconnectGroupUri'] = nil if mapping_attr['logicalInterconnectGroupUri'] == 'nil'
      end
    end
    data
  end

  def resource_update(data, resourcetype)
    current_resource = resourcetype.find_by(@client, unique_id).first
    return false unless current_resource
    current_attributes = current_resource.data
    new_name_validation(data, resourcetype)
    raw_merged_data = current_attributes.merge(data)
    updated_data = Hash[raw_merged_data.to_a - current_attributes.to_a]
    pretty updated_data
    current_resource.update(enclosure_group_parse(updated_data)) unless updated_data.empty?
    @property_hash[:data] = current_resource.data
    true
  end
end
