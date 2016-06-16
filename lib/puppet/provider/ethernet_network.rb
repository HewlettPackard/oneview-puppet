# ============== Ethernet Network methods ==============
# Returns the result of a network search by name
def get_ethernet_network(name)
  matches = OneviewSDK::EthernetNetwork.find_by(@client, name: name)
  return matches
end

# Returns the result of a network search using all data provided
def find_ethernet_networks(data)
  matches = OneviewSDK::EthernetNetwork.find_by(@client, data)
  return matches
end

def ethernet_network_update(data, ethernet_network, process)
  data['name'] = data['new_name'] if data['new_name']
  data.delete('connectionTemplateUri') if data['connectionTemplateUri'] == nil
  raw_merged_data = ethernet_network.data.merge(data)
  updated_data = Hash[raw_merged_data.to_a-ethernet_network.data.to_a]
  if updated_data.size > 0
    updated_data.delete('new_name') if updated_data['new_name']
    ethernet_network.update(updated_data)
    Puppet.notice("#{process} updated: #{updated_data.inspect} ")
  end
end

def bulk_parse(data)
  data.each do |key, value|
    data[value] = :vlanIdRange if key == 'vlanIdRange'
  end
  data
end
