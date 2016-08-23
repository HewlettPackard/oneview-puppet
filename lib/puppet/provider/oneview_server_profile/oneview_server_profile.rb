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

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'login'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_server_profile).provide(:oneview_server_profile) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::ServerProfile
    @data = {}
  end

  def exists?
    @data = data_parse
    empty_data_check([:found, :get_available_targets, :get_available_networks, :get_available_servers, :get_compliance_preview,
                      :get_messages, :get_profile_ports, :get_transformation, :destroy])
    # gets the connections' uris
    connections_parse if @data['connections']
    # gets the hash of filters for queries; in case it does not exist, query will be nil
    @query = @data.delete('query_parameters')
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    return true if resource_update(@data, @resourcetype)
    @resourcetype.new(@client, @data).create
  end

  def destroy
    server_profiles = @resourcetype.find_by(@client, @data)
    raise('There were no matching server profiles in the Appliance.') if server_profiles.empty?
    server_profiles.map(&:delete)
  end

  def found
    find_resources
  end

  # Patch operation
  def update_from_template
    get_single_resource_instance.update_from_template
  end

  def get_available_targets
    Puppet.notice("\n\nServer Profile Available Targets\n")
    pretty @resourcetype.get_available_targets(@client, @query)
    true
  end

  def get_available_networks
    Puppet.notice("\n\nServer Profile Available Networks\n")
    if @data['name'] || @data['uri']
      pretty get_single_resource_instance.get_available_networks
    else
      pretty @resourcetype.get_available_networks(@client, @query)
    end
    true
  end

  def get_available_servers
    Puppet.notice("\n\nServer Profile Available Targets\n")
    pretty @resourcetype.get_available_servers(@client, @query)
    true
  end

  def get_available_storage_systems
    Puppet.notice("\n\nServer Profile Available Storage Systems\n")
    raise('You must specify the following query attributes: enclosureGroupUri and serverHardwareTypeUri.') unless
      @query_parameters['enclosureGroupUri'] && @query_parameters['serverHardwareTypeUri']
    pretty @resourcetype.get_available_storage_systems(@client, @query)
    true
  end

  def get_available_storage_system
    Puppet.notice("\n\nServer Profile Available Storage System\n")
    raise('You must specify the following query attributes: enclosureGroupUri, serverHardwareTypeUri and storageSystemId.') unless
      @query_parameters['enclosureGroupUri'] && @query_parameters['storageSystemId'] && @query_parameters['serverHardwareTypeUri']
    pretty @resourcetype.get_available_storage_system(@client, @query)
    true
  end

  def get_profile_ports
    Puppet.notice("\n\nServer Profile Compliance Preview\n")
    pretty @resourcetype.get_profile_ports(@client, @query)
    true
  end

  def get_compliance_preview
    Puppet.notice("\n\nServer Profile Compliance Preview\n")
    pretty get_single_resource_instance.get_compliance_preview
    true
  end

  def get_messages
    Puppet.notice("\n\nServer Profile Messages\n")
    pretty get_single_resource_instance.get_messages
    true
  end

  def get_transformation
    Puppet.notice("\n\nServer Profile Transformation\n")
    pretty get_single_resource_instance.get_transformation(@query)
    true
  end
end
