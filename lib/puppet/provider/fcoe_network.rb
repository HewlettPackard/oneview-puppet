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
def fcoe_network_update(resource, fcoe_network, process)
  # process = name of the running proccess
  data = data_parse(resource)
  new_name_exists = true
  if data['new_name']
    # checks if name is within the attr to be changed
    new_name = data['new_name']
    new_name_exists = false if !get_fcoe_network(new_name).first
    # flag, true if exists
    data.delete('new_name')
  end
  existing_fcoe_network = fcoe_network.first.data
  # new data to be checked for changes
  data.delete('connectionTemplateUri') if data['connectionTemplateUri'] == nil
  # the connectionTemplateUri can only be nil at its creation
  data.delete('vlanId') if data['vlanId']
  # in case a new vlanId exists, as it cannot be changed
  data.delete('modified')
  # field not considered for comparison
  updated_data = existing_fcoe_network.merge(data)
  # new hash / difference between old and new ones
  updated_data['name'] = new_name if new_name_exists == false
  # Puppet.warning('There is another fcoe network with the same name.') if new_name_exists
  if updated_data != existing_fcoe_network
    # if there's any difference..
    updated_data = Hash[updated_data.to_a-existing_fcoe_network.to_a]
    # hash with different data remaining
    fcoe_network.first.update(updated_data)
    # the actual update on the# hash with different data remaining
    Puppet.notice("#{process} updated: #{updated_data.inspect}")
  end
end
