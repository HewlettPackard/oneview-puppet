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

# ============== Volume methods ==============

# Returns the result of an volume search by name
def get_volume(name)
  matches = OneviewSDK::Volume.find_by(@client, name: name)
  return matches
end

# Returns the result of an volume search using all data provided
def find_volumes(data)
  matches = OneviewSDK::Volume.find_by(@client, data)
  return matches
end

# Compares and updates the volume if necessary
# process = name of the running proccess
def volume_update(resource, volume, process)
  data = data_parse(resource)
  new_name_exists = true
  # checks if name is within the attr to be changed
  if data['new_name']
    new_name = data['new_name']
    # flag, true if exists
    new_name_exists = false unless get_volume(new_name)
    data.delete('new_name')
  end
  # new data to be checked for changes
  existing_volume = volume.data
  # field not considered for comparison
  data.delete('modified')
  # new hash / difference between old and new ones
  updated_data = existing_volume.merge(data)
  updated_data['name'] = new_name if new_name_exists == false
  # if there's any difference..
  if updated_data != existing_volume
    # hash with different data remaining
    updated_data = Hash[updated_data.to_a-existing_volume.to_a]
    # the actual update on the# hash with different data remaining
    volume.update(updated_data) if volume.retrieve!
    Puppet.notice("#{process} updated: #{updated_data.inspect}")
  end
end
