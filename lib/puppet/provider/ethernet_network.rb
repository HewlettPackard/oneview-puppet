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

# Compares and updates the ethernet network if necessary
# process = name of the running proccess
def ethernet_network_update(resource, ethernet_network, process)

  data = data_parse(resource)
  # checks if name is within the attr to be changed
  new_name_exists = true
  if data['new_name']
    new_name = data['new_name']
    # true if exists
    new_name_exists = false if !get_ethernet_network(new_name).first
    data.delete('new_name')
  end
  # new data to be checked for changes
  existing_ethernet_network = ethernet_network.first.data
  # checks whether the vlanId has been changed
  if data['vlanId'].to_s != existing_ethernet_network['vlanId'].to_s
    # Puppet.warning("Update operation does not support vlanId changing.")
  end
  # the connectionTemplateUri can only be nil at its creation
  data.delete('connectionTemplateUri') if data['connectionTemplateUri'] == nil
   # in case a new vlanId exists, as it cannot be changed
   # field not considered for comparison
  data.delete('vlanId') if data['vlanId']
  data.delete('modified')
  # new hash / difference between old and new ones
  updated_data = existing_ethernet_network.merge(data)
  updated_data['name'] = new_name if new_name_exists == false
  # Puppet.warning('There is another ethernet network with the same name.')
  # if new_name_exists
  if updated_data != existing_ethernet_network  # if there's any difference..
    # hash with different data remaining
    updated_data = Hash[updated_data.to_a-existing_ethernet_network.to_a]
    # the actual update on the# hash with different data remaining
    ethernet_network.first.update(updated_data)
    Puppet.notice("#{process} updated: #{updated_data.inspect} ")
  end
end
