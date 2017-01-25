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

require_relative '../oneview_resource'

Puppet::Type::Oneview_san_manager.provide :c7000 do
  desc 'Provider for OneView SAN Manager using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    api_version = login[:api_version] || 200
    @resourcetype ||= if api_version == 200
                        OneviewSDK::API200::SANManager
                      else
                        Object.const_get("OneviewSDK::API#{api_version}::C7000::SANManager")
                      end
    # Initializes the data so it is parsed only on exists and accessible throughout the methods
    # This is not set here due to the 'resources' variable not being accessible in initialize
    @data ||= {}
  end

  # Provider methods
  def exists?
    @data = data_parse
    parse_provider_uri
    pretty @data
    empty_data_check
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    return true if resource_update(@data, @resourcetype)
    @resourcetype.new(@client, @data).add
    @property_hash[:ensure] = :present
    @property_hash[:data] = @data
    true
  end

  def destroy
    san_manager = get_single_resource_instance
    Puppet.notice "\n\n Removing san_manager named: #{san_manager['name']}, with uri: #{san_manager['uri']}\n"
    san_manager.remove
    @property_hash.clear
  end

  def found
    find_resources
  end

  def parse_provider_uri
    return unless @data['providerUri']
    return if @data['providerUri'].to_s[0..6].include?('/rest/')
    @data['providerDisplayName'] = @data.delete('providerUri')
  end
end
