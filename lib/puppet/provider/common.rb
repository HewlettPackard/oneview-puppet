# ============== Common methods ==============

# Removes quotes from nil and false values
def data_parse(resource_data)
  data = resource['data']
  data.each do |key,value|
    data[key] = nil if value == 'nil'
    data[key] = false if value == 'false'
    data[key] = true if value == 'true'
  end
  return data
end

# ============== Ethernet Network methods ==============

# Returns the result of a network search by name
def get_ethernet_network(name)
  matches = OneviewSDK::EthernetNetwork.find_by(@client, name: name)
  return matches
end

# Compares and updates the ethernet network if necessary
def ethernet_network_update(resource, ethernet_network)
  data = data_parse(resource)                                             # new data to be checked for changes
  existing_ethernet_network = ethernet_network.first.data
  if data['vlanId'].to_s != existing_ethernet_network['vlanId'].to_s            # checks whether the vlanId has been changed
    Puppet.warning("Update operation does not support vlanId changing, ignoring...")
  end
  data.delete('connectionTemplateUri') if data['connectionTemplateUri'] == nil  # the connectionTemplateUri can only be nil at its creation
  data.delete('vlanId') if data['vlanId']                                       # in case a new vlanId exists, as it cannot be changed
  data.delete('modified')                                                       # field not considered for comparison
  updated_data = existing_ethernet_network.merge(data)                          # new hash / difference between old and new ones
  if updated_data != existing_ethernet_network                                  # if there's any difference...
    updated_data = Hash[updated_data.to_a-existing_ethernet_network.to_a]       # hash with different data remaining
    ethernet_network.first.update(updated_data)                                 # the actual update on the
    Puppet.warning("Updated: #{updated_data.inspect} ")                         # shows what
  end
end

# ============== --- methods ==============


=begin  POSSIBLY WORTH DOING AN UPDATE_PARSE TO PARSE OPTIONS FOR UPDATE AND REMOVE NOT ALLOWED ONES
def update_parse(resource_data)
  data = resource['data']
  data.each do |key,value|
    data[key] = nil if value == 'nil'
    data[key] = false if value == 'false'
    data[key] = true if value == 'true'
  end
  return data
end
=end
