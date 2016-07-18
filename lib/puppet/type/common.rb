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
  client = OneviewSDK::Client.new(login)
  uri_recursive_hash(client, data)
  data
end

def uri_recursive_hash(client, data)
  data.each do |key, value|
    # in case the key is either an array or hash
    hash_array_check(client, data[key])
    # next if -the uri is already declared- or -the parameter name does not require a uri-
    next if value.to_s[0..6].include?('/rest/') || !(key.to_s.include? 'Uri')
    # looks for the resource
    resource = get_class(key).find_by(client, name: value)
    # fails if resource returns an empty hash (no results)
    raise 'One or more resources have not been found in the Appliance.' if resource.empty?
    # replaces the parameter name by its uri
    data[key] = resource.first.data['uri']
  end
end

# Broken-down blocks

# keeps uri_recursive_hash going in case of String, sends to another method
# in case of arrays or hashes
def hash_array_check(client, data)
  uri_recursive_hash(client, data) if data.is_a?(Hash)
  uri_recursive_array(client, data) if data.is_a?(Array)
end

# turns the array into a hash
def uri_recursive_array(client, data)
  data.each do |item|
    uri_recursive_hash(client, item) if item.is_a?(Hash)
  end
end

def get_class(key)
  # this gets the SDK class based on key.to_s, removing 'Uri' and capitalizing the 1st letter
  Object.const_get("OneviewSDK::#{key.to_s[0].upcase}#{key[1..key.size - 4]}")
end
