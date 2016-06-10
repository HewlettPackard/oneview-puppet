# ============== FCoE Network methods ==============

# Returns the result of a network search by name
def get_fcoe_network(name)
  matches = OneviewSDK::FCoENetwork.find_by(@client, name: name)
  return matches
end

# Returns the result of a network search using all data provided
def find_fcoe_networks(data)
  matches = OneviewSDK::FCoENetwork.find_by(@client, data)
  return matches
end

# Compares and updates the fcoe network if necessary
# process = name of the running proccess
def fcoe_network_update(resource, fcoe_network, process)
  data = data_parse(resource)
  new_name_exists = true
  # checks if name is within the attr to be changed
  if data['new_name']
    new_name = data['new_name']
    # flag, true if exists
    new_name_exists = false if !get_fcoe_network(new_name).first
    data.delete('new_name')
  end
  # new data to be checked for changes
  existing_fcoe_network = fcoe_network.first.data
  # the connectionTemplateUri can only be nil at its creation
  data.delete('connectionTemplateUri') if data['connectionTemplateUri'] == nil
  # in case a new vlanId exists, as it cannot be changed
  data.delete('vlanId') if data['vlanId']
  # field not considered for comparison
  data.delete('modified')
  # new hash / difference between old and new ones
  updated_data = existing_fcoe_network.merge(data)
  # Puppet.warning('There is another fcoe network with the same name.') if new_name_exists
  updated_data['name'] = new_name if new_name_exists == false
  # if there's any difference..
  if updated_data != existing_fcoe_network
    # hash with different data remaining
    updated_data = Hash[updated_data.to_a-existing_fcoe_network.to_a]
    # the actual update on the# hash with different data remaining
    fcoe_network.first.update(updated_data)
    Puppet.notice("#{process} updated: #{updated_data.inspect}")
  end
end
