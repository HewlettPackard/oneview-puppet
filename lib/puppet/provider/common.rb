# Removes quotes from nil and false values
def attributes_parse(resource_attributes)
  attributes = resource['attributes']
  attributes.each do |key,value|
    attributes[key] = nil if value == 'nil'
    attributes[key] = false if value == 'false'
    attributes[key] = true if value == 'true'
  end
  return attributes
end

def ethernet_network_update(resource, ethernet_network)
  data = attributes_parse(resource)                               # new data to be checked for changes
  existing_ethernet_network = ethernet_network.first.data
  if data['vlanId'].to_s != existing_ethernet_network['vlanId'].to_s            # checks whether the vlanId has been changed
    Puppet.warning("Update operation does not support vlanId changing, ignoring...")
  end
  data.delete('connectionTemplateUri') if data['connectionTemplateUri'] == nil  # the connectionTemplateUri can only be nil at its creation
  data.delete('vlanId') if data['vlanId']                                       # in case a new vlanId exists, as it cannot be changed
  data.delete('modified')                                                       # field not considered for comparison
  updated_data = existing_ethernet_network.merge(data)                          # new hash / difference between old and new ones
  if updated_data != existing_ethernet_network                                  # if there's any difference...
    updated_data = Hash[updated_data.to_a-existing_ethernet_network.to_a]       # hash with different attributes remaining
    ethernet_network.first.update(updated_data)                                 # the actual update on the
    Puppet.warning("Updated: #{updated_data.inspect} ")                         # shows what
  end
end


=begin  POSSIBLY WORTH DOING AN UPDATE_PARSE TO PARSE OPTIONS FOR UPDATE AND REMOVE NOT ALLOWED ONES
def update_parse(resource_attributes)
  attributes = resource['attributes']
  attributes.each do |key,value|
    attributes[key] = nil if value == 'nil'
    attributes[key] = false if value == 'false'
    attributes[key] = true if value == 'true'
  end
  return attributes
end
=end

# Returns the result of a network search by name
def get_ethernet_network(name)
  matches = OneviewSDK::EthernetNetwork.find_by(@client, name: name)
  return matches
end
