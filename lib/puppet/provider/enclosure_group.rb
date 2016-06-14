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

# ============== Enclosure Group methods ==============

def enclosure_group_parse(data)
  if data['interconnectBayMappingCount']
    data['interconnectBayMappingCount'] = Integer(data['interconnectBayMappingCount'])
  end

  if data['interconnectBayMappings']
    data['interconnectBayMappings'].each do |k|
      k['interconnectBay'] = k['interconnectBay'].to_i
      k['logicalInterconnectGroupUri'] = nil if k['logicalInterconnectGroupUri'] == "nil"
    end
  end

  data
end

def enclosure_group_update(data, enclosure_group, process)
  data['name'] = data['new_name'] if data['new_name']
  raw_merged_data = enclosure_group.data.merge(data)
  updated_data = Hash[raw_merged_data.to_a-enclosure_group.data.to_a]
  if updated_data.size > 0
    enclosure_group.update(updated_data)
    updated_data.delete('new_name') if updated_data['new_name']
    Puppet.notice("#{process} updated: #{updated_data.inspect} ")
  end
end

def get_enclosure_group(name)
  enclosure_group = OneviewSDK::EnclosureGroup.find_by(@client, name: name)
  enclosure_group.first
end
