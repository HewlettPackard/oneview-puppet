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

# ============== Storage System methods ==============

# Returns the result of an storage system search by name
def get_storage_system(name)
  matches = OneviewSDK::StorageSystem.find_by(@client, name: name)
  return matches
end

# Returns the result of an storage system search using all data provided
def find_storage_systems(data)
  matches = OneviewSDK::StorageSystem.find_by(@client, data)
  return matches
end

# Compares and updates the Storage System if necessary
# process = name of the running proccess
def storage_system_update(resource, storage_system, process)
  data = data_parse(resource)
  new_name_exists = true
  # checks if name is within the attr to be changed
  if data['new_name']
    new_name = data['new_name']
    # flag, true if exists
    new_name_exists = false unless get_storage_system(new_name)
    data.delete('new_name')
  end
  # new data to be checked for changes
  existing_storage_system = storage_system.data
  # field not considered for comparison
  data.delete('modified')
  # new hash / difference between old and new ones
  updated_data = existing_storage_system.merge(data)
  updated_data['name'] = new_name if new_name_exists == false
  # if there's any difference..
  if updated_data != existing_storage_system
    # hash with different data remaining
    updated_data = Hash[updated_data.to_a-existing_storage_system.to_a]
    # the actual update on the# hash with different data remaining
    storage_system.update(updated_data) if storage_system.retrieve!
    Puppet.notice("#{process} updated: #{updated_data.inspect}")
  end
end
