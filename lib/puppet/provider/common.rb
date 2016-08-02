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

# ============== Common methods ==============

require 'json'

def pretty(arg)
  return puts arg if arg.instance_of?(String)
  puts JSON.pretty_generate(arg)
end

# Removes quotes from nil and false values
def data_parse(data = {})
  data = resource['data'] ||= data
  data.each do |key, value|
    data[key] = nil if value == 'nil'
    data[key] = false if value == 'false'
    data[key] = true if value == 'true'
    data[key] = data[key].to_i if key == 'vlanId'
  end
  data
end

# FIXME: method created because data_parse (above) was returning hashes with booleans as strings
# to be debugged in the future
def data_parse_interconnect(data)
  data.each do |key, value|
    data[key] = nil if value == 'nil'
    data[key] = false if value == 'false'
    data[key] = true if value == 'true'
    data[key] = data[key].to_i if key == 'vlanId'
  end
  data
end

def resource_update(data, resourcetype)
  current_resource = resourcetype.find_by(@client, unique_id).first
  return false unless current_resource
  current_attributes = current_resource.data
  new_name_validation(data, resourcetype)
  raw_merged_data = current_attributes.merge(data)
  updated_data = Hash[raw_merged_data.to_a - current_attributes.to_a]
  current_resource.update(updated_data) unless updated_data.empty?
  @property_hash[:data] = current_resource.data
  true
end

def new_name_validation(data, resourcetype)
  # Validation for name change on resource through flag 'new_name'
  if data['new_name']
    new_resource_name_used = resourcetype.find_by(@client, name: data['new_name']).first
    data['name'] = data.delete('new_name') unless new_resource_name_used
  end
end

def get_single_resource_instance
  # Expects to find exactly 1 resources with the data provided, otherwise fails
  # This should NOT be used for deletes/destroys as it can be used without a unique identifier in a context where only one resouce exists.
  found_resource = @resourcetype.find_by(@client, @data)
  raise 'More than one resource matched the data specified. Specify a unique identifier on data.' if found_resource.size > 1
  raise 'No resources with the specified data specified were found. Specify a valid unique identifier on data.' if found_resource.empty?
  found_resource.first
end

def objectfromstring(str)
  # capitalizing the first letter + getting the remaining ones as they are
  # '.capitalize' alone will return something like Firstlettercapitalizedonly
  Object.const_get("OneviewSDK::#{str.to_s[0].upcase}#{str[1..str.size]}")
end

def find_resources
  # Searches ServerHardware with data matching the manifest data
  retrieved_resources = @resourcetype.find_by(@client, @data)
  resource_name = @resourcetype.to_s.split('::')
  # If resources are found, iterate through them and notify. Else just notify.
  raise "\n\nNo #{resource_name[1]} with the specified data were found on the Oneview Appliance\n" if retrieved_resources.empty?
  retrieved_resources.each do |retrieved_resource|
    Puppet.notice "\n\n Found matching #{resource_name[1]} #{retrieved_resource['name']} "\
    "(URI: #{retrieved_resource['uri']}) on Oneview Appliance\n"
  end
  true
end

# Gets a resource by its unique identifier (generally name or uri)
def unique_id
  raise('A resource name or uri must be declared in data for the current operation') unless @data['name'] || @data['uri'] || @data['id']
  id = {}
  if @data['name']
    id[:name] = @data['name']
  elsif @data['uri']
    id[:uri] = @data['uri']
  else
    id[:id] = @data['id']
  end
  id
end
