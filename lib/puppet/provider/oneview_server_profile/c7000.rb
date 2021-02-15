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

require_relative '../oneview_resource'

Puppet::Type.type(:oneview_server_profile).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Server Profiles using the C7000 variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  # Handles special case where destroy can delete several different server profiles.
  # Also calls load_template method to auto-fill all fields with the values from the specified template.
  def exists?
    prepare_environment
    load_template(@data['serverProfileTemplateUri'], 'new_profile')
    return @resource_type.find_by(@client, @data).any? if resource['ensure'].to_sym == :absent
    super([nil, :found, :get_available_targets, :get_available_networks, :get_available_servers, :get_compliance_preview,
           :get_messages, :get_profile_ports, :get_transformation, :absent])
  end

  # Gets the connection uris if those exist and remove 'query_parameters' from @data
  def data_parse
    connections_parse if @data['connectionSettings']
    @query ||= @data.delete('query_parameters')
  end

  # This method deletes all the server profiles that match the data passed in. Use with caution.
  def destroy
    super(:multiple_delete)
  end

  # Patch operation
  def update_from_template
    get_single_resource_instance.update_from_template
  end

  def get_available_targets
    Puppet.notice("\n\nServer Profile Available Targets\n")
    pretty @resource_type.get_available_targets(@client, @query)
    true
  end

  def get_available_networks
    Puppet.notice("\n\nServer Profile Available Networks\n")
    if @data['name'] || @data['uri']
      pretty get_single_resource_instance.get_available_networks
    else
      pretty @resource_type.get_available_networks(@client, @query)
    end
    true
  end

  def get_available_servers
    Puppet.notice("\n\nServer Profile Available Targets\n")
    pretty @resource_type.get_available_servers(@client, @query)
    true
  end

  def get_available_storage_systems
    Puppet.notice("\n\nServer Profile Available Storage Systems\n")
    query_ok = @query['enclosureGroupUri'] && @query['serverHardwareTypeUri']
    raise 'You must specify the following query attributes: enclosureGroupUri and serverHardwareTypeUri.' unless query_ok
    pretty @resource_type.get_available_storage_systems(@client, @query)
    true
  end

  def get_available_storage_system
    Puppet.notice("\n\nServer Profile Available Storage System\n")
    raise 'You must specify query attributes for this ensure method' unless @query
    query_ok = @query['enclosureGroupUri'] && @query['storageSystemId'] && @query['serverHardwareTypeUri']
    raise 'You must specify the following query attributes: enclosureGroupUri, serverHardwareTypeUri and storageSystemId.' unless query_ok
    pretty @resource_type.get_available_storage_system(@client, @query)
    true
  end

  def get_profile_ports
    Puppet.notice("\n\nServer Profile Compliance Preview\n")
    pretty @resource_type.get_profile_ports(@client, @query)
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
