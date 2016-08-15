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

require File.expand_path(File.join(File.dirname(__FILE__), '../provider', 'login'))

def uri_validation(data)
  @client = OneviewSDK::Client.new(login)
  uri_recursive_hash(data)
  data
end

def uri_recursive_hash(data)
  data.each do |key, value|
    @value = value
    # in case the key is either an array or hash
    hash_array_check(data[key])
    # next if -the uri is already declared- or -the parameter name does not require a uri- or -value is nil-
    next if value.to_s[0..6].include?('/rest/') || !((key.to_s.include? 'Uri') || (key.to_s == 'uri')) || value.to_s == 'nil' ||
            value.nil? || key.to_s == 'networkUri'
    data[key] = get_uri(key)
  end
end

# Broken-down blocks

# Gets the Uri for the resource
def get_uri(key)
  parsed_key = special_resources_check(key)
  # looks for the resource
  resource = get_class(parsed_key).find_by(@client, name: @value)
  # fails if resource returns an empty hash (no results)
  raise "'#{@value}' has not been found in the Appliance." if resource.empty?
  # replaces the parameter name by its uri
  resource.first.data['uri']
end

# Check for special/exceptions to the uri default search
def special_resources_check(key)
  special_resources = %w(resourceUri actualNetworkUri expectedNetworkUri uri firmwareBaselineUri actualNetworkSanUri dependentResourceUri
                         sspUri associatedUplinkSetUri associatedTaskUri parentTaskUri snapshotPoolUri permittedSwitchTypeUri
                         permittedInterconnectTypeUri volumeStoragePoolUri volumeStorageSystemUri)
  return key unless special_resources.include?(key)
  # Assigns the correct key to be used with find_by, and adds 'Uri' to the end of the key
  # to make it compatible with the get_class method which will be called after this
  new_key = special_resources_assign(key)
  new_key + 'Uri'
end

# Helper for special_resource_check to assign the correct values to the special resources
def special_resources_assign(key)
  return generic_resource_fixer if %w(resourceUri actualNetworkUri expectedNetworkUri uri).include?(key)
  case key
  when 'firmwareBaselineUri', 'sspUri' then 'FirmwareDriver'
  when 'actualNetworkSanUri' then 'ManagedSAN'
  when 'dependentResourceUri' then 'LogicalInterconnect'
  when 'snapshotPoolUri', 'volumeStoragePoolUri' then 'StoragePool'
  when 'volumeStorageSystemUri' then 'StorageSystem'
  when 'associatedUplinkSetUri' then 'UplinkSet'
  when 'parentTaskUri', 'associatedTaskUri' then 'Task'
  when 'permittedSwitchTypeUri' then 'Switch'
  when 'permittedInterconnectTypeUri' then 'Interconnect'
  end
end

# This is used on generic resources calls like 'resourceUri', where the type is required with the name
def generic_resource_fixer
  value_array = @value.strip.split(',').map(&:strip)
  @value = value_array[0]
  value_array[1]
end

# keeps uri_recursive_hash going in case of String, sends to another method
# in case of arrays or hashes
def hash_array_check(data)
  uri_recursive_hash(data) if data.is_a?(Hash)
  uri_recursive_array(data) if data.is_a?(Array)
end

# turns the array into a hash
def uri_recursive_array(data)
  data.each do |item|
    uri_recursive_hash(item) if item.is_a?(Hash)
  end
end

def get_class(key)
  # this gets the SDK class based on key.to_s, removing 'Uri' and capitalizing the 1st letter
  Object.const_get("OneviewSDK::#{key.to_s[0].upcase}#{key[1..key.size - 4]}")
end
