################################################################################
# (C) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
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

require_relative 'login'

def uri_validation(data)
  @client ||= OneviewSDK::Client.new(login)
  uri_recursive_hash(data)
  data
end

def uri_recursive_hash(data)
  data.each do |key, value|
    @value = value
    # in case the key is either an array or hash
    hash_array_check(data[key])
    # next if -the uri is already declared- or -the parameter name does not require a uri- or -value is nil-
    next if value.to_s[0..6].include?('/rest/') || !(key.to_s.include?('Uri') || key.to_s == 'uri' || key.to_s.end_with?('URI')) ||
            value.nil? || %w(null nil).include?(value.to_s) || exception_to_be_treated_within_provider(key)
    data[key] = get_uri(key)
  end
end

# Broken-down blocks
def exception_to_be_treated_within_provider(key)
  # TODO: Remove the enclosureUris from this list once the issue(#194) is fixed.
  exception_list = %w(networkUris networkUri hotfixUris fcNetworkUris fcoeNetworkUris connectionUri providerUri
                      permittedInterconnectTypeUri permittedSwitchTypeUri internalNetworkUris enclosureUris)
  true if exception_list.include?(key)
end

# Gets the Uri for the resource
def get_uri(key)
  ov_class = get_class(special_resources_check(key))
  ov_resource = ov_class.find_by(@client, name: @value)
  if sas_resources_check(ov_resource, ov_class)
    ov_class = ov_class.to_s.split('::')[-1]
    ov_resource = OneviewSDK.resource_named("SAS#{ov_class}", login[:api_version], :Synergy).find_by(@client, name: @value)
  end
  # fails if ov_resource returns an empty hash (no results)
  raise "'#{@value}' has not been found in the Appliance." if ov_resource.empty?
  # replaces the parameter name by its uri
  ov_resource.first.data['uri']
end

# Check for special/exceptions to the uri default search
def special_resources_check(key)
  special_resources = %w(resourceUri actualNetworkUri expectedNetworkUri uri firmwareBaselineUri actualNetworkSanUri dependentResourceUri
                         sspUri associatedUplinkSetUri associatedTaskUri parentTaskUri snapshotPoolUri volumeStoragePoolUri
                         volumeStorageSystemUri baselineUri mountUri nativeNetworkUri enclosureUris oeBuildPlanURI osVolumeURI
                         osDeploymentPlanUri)
  return key unless special_resources.include?(key)
  # Assigns the correct key to be used with find_by, and adds 'Uri' to the end of the key
  # to make it compatible with the get_class method which will be called after this
  new_key = special_resources_assign(key)
  new_key + 'Uri'
end

# Helper for special_resource_check to assign the correct values to the special resources
def special_resources_assign(key)
  return generic_resource_fixer if %w(resourceUri actualNetworkUri expectedNetworkUri uri mountUri).include?(key)
  case key
  # OneView resources
  when 'firmwareBaselineUri', 'sspUri', 'baselineUri' then 'FirmwareDriver'
  when 'actualNetworkSanUri' then 'ManagedSAN'
  when 'dependentResourceUri' then 'LogicalInterconnect'
  when 'snapshotPoolUri', 'volumeStoragePoolUri' then 'StoragePool'
  when 'volumeStorageSystemUri' then 'StorageSystem'
  when 'associatedUplinkSetUri' then 'UplinkSet'
  when 'parentTaskUri', 'associatedTaskUri' then 'Task'
  when 'nativeNetworkUri' then 'EthernetNetwork'
  # TODO: Uncomment this line, once array handling is done for enclosureUris for issue #194
  # when 'enclosureUris' then 'Enclosure'
  when 'osDeploymentPlanUri' then 'OSDeploymentPlan'
  # Image Streamer resources
  when 'oeBuildPlanURI' then 'BuildPlan'
  when 'osVolumeURI' then 'OSVolume'
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
  sub_module = OneviewSDK::ImageStreamer::Client == @client.class ? 'ImageStreamer::' : ''
  variant = OneviewSDK::Client == @client.class && @client.api_version > 200 ? "#{resource_variant}::" : ''
  resource_name = "#{key.to_s[0].upcase}#{key[1..key.size - 4]}"
  Object.const_get("OneviewSDK::#{sub_module}API#{@client.api_version}::#{variant}#{resource_name}")
end

# Used for handling uris that refer to SAS resources
def sas_resources_check(ov_resource, ov_class)
  return false unless %w(LogicalInterconnectGroup LogicalInterconnect Interconnect).include?(ov_class.to_s.split('::')[-1])
  ov_resource.empty? && resource_variant.to_sym == :Synergy
end
