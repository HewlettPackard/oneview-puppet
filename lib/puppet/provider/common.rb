################################################################################
# (C) Copyright 2016-2020 Hewlett Packard Enterprise Development LP
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

require 'json'
require_relative 'uri_parsing'

# ============== Common methods ==============

def pretty(arg)
  return puts arg if arg.instance_of?(String)
  puts JSON.pretty_generate(arg)
end

# Prepares environment variables needed to manage most resources.
# Transforms 'nil', 'false' and 'true' values passed in as strings into their respective types.
# Creates the @data global variable.
# Calls the 'data_parse' method specific to each resource if it exists.
# Retrieves resource uris using names passed inside uri fields.
def prepare_environment
  data = resource['data'] || {}
  data.each do |key, value|
    data[key] = nil if value == 'nil'
    data[key] = false if value == 'false'
    data[key] = true if value == 'true'
    data[key] = data[key].to_i if key == 'vlanId'
  end
  uri_validation(data)
  @data = data
  data_parse
end

# Updates resource if it exists and is different from the expected.
# Returns false if resource does not exist and true if it exists or if it was updated.
def resource_update
  @new_name = @data.delete('new_name')
  @item = @resource_type.new(@client, @data)
  return false unless @item.retrieve!
  parse_new_name
  if @item.like?(@data)
    Puppet.notice "#{@resource_type} #{@data['name']} is up to date."
  else
    Puppet.notice "#{@resource_type} #{@data['name']} differs from resource in appliance."
    Puppet.debug "Current attributes: #{JSON.pretty_generate(@item.data)}"
    Puppet.debug "Desired attributes: #{JSON.pretty_generate(@data)}"
    @item.update(@data)
    @property_hash[:data] = @item.data
  end
  true
end

# Validation for name change on resource through flag 'new_name'
def parse_new_name
  return unless @new_name
  raise 'new_name field contains an existing resource name.' if @resource_type.new(@client, name: @new_name).retrieve!
  @data['name'] = @new_name
end

def get_single_resource_instance
  # Expects to find exactly 1 resources with the data provided, otherwise fails
  # This should NOT be used for deletes/destroys as it can be used without a unique identifier in a context where only one resouce exists.
  found_resource = @resource_type.find_by(@client, @data)
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
  retrieved_resources = @resource_type.find_by(@client, @data)
  resource_name = @resource_type.to_s.split('::').last
  # If resources are found, iterate through them and notify. Else just notify.
  raise "\n\nNo #{resource_name} with the specified data were found on the Oneview Appliance\n" if retrieved_resources.empty?
  retrieved_resources.each do |retrieved_resource|
    Puppet.notice "\n\n Found matching #{resource_name} #{retrieved_resource['name']} "\
    "(URI: #{retrieved_resource['uri']}) on Oneview Appliance\n"
  end
  true
end

# Gets a resource by its unique identifier (generally name or uri)
def unique_id
  id = {}
  %w(uri name id providerDisplayName credentials providerUri poolName).each { |key| id[key] = @data[key] if @data[key] }
  raise 'A unique identifier for the resource must be declared in data for the current operation' if id.empty?
  id
end

# Returns an error in case the state requires @data not to be empty
# Takes as arguments the states that can be executed without data
def empty_data_check(states = [nil, :found])
  raise('This action requires the resource data to be declared in the manifest.') if @data.empty? && !states.include?(resource['ensure'])
  return true if states.include?(resource['ensure'])
end

# Returns the connection uri based on its name and functionType (Ethernet, FC, Network Set)
# FCoE to be added (no need so far)
def connections_parse
  @data.each_key do |key|
    next unless @data[key].include?('manageConnections')
    @data[key].each do |conn, value|
      next unless conn.include?('connections')
      network_parse(value)
    end
  end
end

# This method will bypass exists method for bulk_delete method
def exists_bulk_method(states = [nil, :found])
  prepare_environment
  @item = @resource_type.new(@client, @data)
  return true if empty_data_check(states)
  @property_hash[:ensure] == :present
end

def network_parse(connections)
  connections.each do |network|
    next if network['networkUri'].to_s[0..6].include?('/rest/')
    type = case network['functionType']
           when 'Ethernet' then 'EthernetNetwork'
           when 'FibreChannel' then 'FCNetwork'
           when 'Set'
             network['functionType'] = 'Ethernet'
             'NetworkSet'
           end
    net = objectfromstring(type).find_by(@client, name: network['networkUri'])
    raise("The network #{network['networkUri']} does not exist in the Appliance.") unless net.first
    network['networkUri'] = net.first['uri']
  end
end

# Retrieve a resource by type and identifier (name or data)
# @param [String, Symbol] type of resource to be retrieved. e.g., :GoldenImage, :FCNetwork
# @param [String, Symbol, Hash] id Name of the resource or Hash of data to retrieve by.
#   Examples: 'EthNet1', { uri: '/rest/fake/123ABC' }
# @param [NilClass, String, Symbol] ret_attribute If specified, returns a specific attribute of the resource.
#   When nil, the complete resource will be returned.
# @param [Module] base_module Module to which the desired class belongs. Usually OneViewSDK or OneviewSDK::ImageStreamer.
# @return [OneviewSDK::Resource] if the `ret_attribute` is nil
# @return [String, Array, Hash] the value of the resource attribute defined by `ret_attribute`
# @raise [OneviewSDK::NotFound] ResourceNotFound if the resource cannot be found
# @raise [OneviewSDK::IncompleteResource] If you don't specify any unique identifiers in `id`
def load_resource(type, id, ret_attribute: nil, base_module: OneviewSDK)
  raise(ArgumentError, 'Must specify a resource type') unless type
  return unless id
  klass = base_module.resource_named(type, api_version, resource_variant)
  data = id.is_a?(Hash) ? id : { name: id }
  r = klass.new(@client, data)
  raise(OneviewSDK::NotFound, "#{type} with data '#{data}' was not found") unless r.retrieve!
  return r unless ret_attribute
  r[ret_attribute]
end

# Retrieve the template to be used for the resource and autofills blank fields with template's values
# @param [String] uri Uri of the resource
# @param [String] method Method specific to the resource which retrieves the require template
# @param [String, Symbol] type Type of resource to be retrieved. e.g., :ServerProfileTemplate, :ServerProfile
# @return [Hash] Updated resource data
# @raise [OneviewSDK::NotFound] ResourceNotFound if the resource cannot be found
def load_template(uri, method, type = :ServerProfileTemplate)
  return unless uri
  template = load_resource(type, uri: uri)
  template_data = template.send(method, @data['name']).data
  resource['data'] = template_data.merge(@data)
end
