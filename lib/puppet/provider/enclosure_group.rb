def enclosure_group_parse(data)
  data['interconnectBayMappingCount'] = Integer(data['interconnectBayMappingCount'])

  data['interconnectBayMappings'].each do |k|
    k['interconnectBay'] = k['interconnectBay'].to_i
    k['logicalInterconnectGroupUri'] = nil if k['logicalInterconnectGroupUri'] == "nil"
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
