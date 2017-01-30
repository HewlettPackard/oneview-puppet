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

Puppet::Type::Oneview_server_profile.provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Server Profiles using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def exists?
    @data = data_parse
    empty_data_check([:found, :get_available_targets, :get_available_networks, :get_available_servers, :get_compliance_preview,
                      :get_messages, :get_profile_ports, :get_transformation, :absent])
    # gets the connections' uris
    connections_parse if @data['connections']
    # gets the hash of filters for queries; in case it does not exist, query will be nil
    @query = @data.delete('query_parameters')
    !@resourcetype.find_by(@client, @data).empty?
  end

  # This destroy deletes all the server profiles that match the data passed in. Use with caution.
  def destroy
    server_profiles = @resourcetype.find_by(@client, @data)
    raise('There were no matching server profiles in the Appliance.') if server_profiles.empty?
    server_profiles.map(&:delete)
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
    query_ok = @query['enclosureGroupUri'] && @query['serverHardwareTypeUri']
    raise 'You must specify the following query attributes: enclosureGroupUri and serverHardwareTypeUri.' unless query_ok
    pretty @resourcetype.get_available_storage_systems(@client, @query)
    true
  end

  def get_available_storage_system
    Puppet.notice("\n\nServer Profile Available Storage System\n")
    raise 'You must specify query attributes for this ensure method' unless @query
    query_ok = @query['enclosureGroupUri'] && @query['storageSystemId'] && @query['serverHardwareTypeUri']
    raise 'You must specify the following query attributes: enclosureGroupUri, serverHardwareTypeUri and storageSystemId.' unless query_ok
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

  def get_sas_logical_jbods
    raise 'This ensure method is not available for C7000.'
  end

  def get_sas_logical_jbod_drives
    raise 'This ensure method is not available for C7000.'
  end

  def get_sas_logical_jbod_attachments
    raise 'This ensure method is not available for C7000.'
  end
end
