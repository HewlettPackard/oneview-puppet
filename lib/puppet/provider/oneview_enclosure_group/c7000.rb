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

Puppet::Type.type(:oneview_enclosure_group).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Enclosure Groups using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods
  def exists?
    @data = enclosure_group_parse(data_parse)
    empty_data_check
    !@resource_type.find_by(@client, @data).empty?
  end

  def create
    return true if resource_update
    @resource_type.new(@client, enclosure_group_parse(@data)).create
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
end
