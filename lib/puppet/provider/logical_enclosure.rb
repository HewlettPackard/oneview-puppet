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

# ============== Logical Enclosure methods ==============

# Returns the result of a network search by name
def get_logical_enclosure(name)
  matches = OneviewSDK::LogicalEnclosure.find_by(@client, name: name)
  matches.each { |network| puts "#{network['name']} #{network['type']}" }
  return matches
end

# Returns the result of a network search using all data provided
def find_logical_enclosures(data)
  matches = OneviewSDK::LogicalEnclosure.find_by(@client, data)
  return matches
end

# Compares and updates the Logical Enclosure if necessary
# process = name of the running proccess
def logical_enclosure_update(resource, logical_enclosure, process)
  data = data_parse(resource)
  new_name_exists = true
  # checks if name is within the attr to be changed
  if data['new_name']
    new_name = data['new_name']
    # flag, true if exists
    new_name_exists = false if !get_logical_enclosure(new_name)
    data.delete('new_name')
  end
  # new data to be checked for changes
  existing_logical_enclosure = logical_enclosure.first.data
  # the connectionTemplateUri can only be nil at its creation
  data.delete('connectionTemplateUri') if data['connectionTemplateUri'] == nil
  # in case a new vlanId exists, as it cannot be changed
  data.delete('vlanId') if data['vlanId']
  # field not considered for comparison
  data.delete('modified')
  # new hash / difference between old and new ones
  updated_data = existing_logical_enclosure.merge(data)
  # Puppet.warning('There is another Logical Enclosure with the same name.') if new_name_exists
  updated_data['name'] = new_name if new_name_exists == false
  # if there's any difference..
  if updated_data != existing_logical_enclosure
    # hash with different data remaining
    updated_data = Hash[updated_data.to_a-existing_logical_enclosure.to_a]
    # the actual update on the# hash with different data remaining
    logical_enclosure.update(updated_data)
    Puppet.notice("#{process} updated: #{updated_data.inspect}")
  end
end
