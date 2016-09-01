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

Puppet::Type.type(:oneview_ethernet_network).provide(:oneview_ethernet_network) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::EthernetNetwork
    @data = {}
  end

  def exists?
    @data = data_parse
    empty_data_check
    @bandwidth = @data.delete('bandwidth') unless @data['vlanIdRange']
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    # Checks if there is a connection template update
    update_connection_template if @bandwidth
    # Checks if the operation is an update, bulk create or neither
    return true if bulk_create_check || resource_update(@data, @resourcetype)
    @resourcetype.new(@client, @data).create
  end

  def destroy
    get_single_resource_instance.delete
  end

  def found
    find_resources
  end

  def get_associated_profiles
    Puppet.notice("\n\nAssociated Profiles\n")
    list = get_single_resource_instance.get_associated_profiles
    if list.eql?('[]')
      Puppet.warning("There are no associated profiles to show.\n")
    else
      puts list
    end
    true
  end

  def get_associated_uplink_groups
    Puppet.notice("\n\nAssociated Uplink Groups\n")
    list = get_single_resource_instance.get_associated_uplink_groups
    if list.eql?('[]')
      Puppet.warning("There are no associated uplink groups to show.\n")
    else
      puts list
    end
    true
  end

  # Retrieves de default connection template bandwidth, compares it to the current network's connection template and updates it if needed
  def reset_default_bandwidth
    @bandwidth = OneviewSDK::ConnectionTemplate.get_default(@client)['bandwidth']
    update_connection_template
  end

  # Helpers

  # Creates bulk networks if there is @data['vlanIdRange']
  def bulk_create_check
    @data['vlanIdRange'] ? @resourcetype.bulk_create(@client, bulk_parse(@data)) : false
  end

  def bulk_parse(data)
    data = Hash[data.map { |k, v| [k.to_sym, v] }]
    data[:bandwidth] = Hash[data[:bandwidth].map { |k, v| [k.to_sym, v.to_i] }]
    data
  end

  # Checks whether the connection template needs to be updated
  def update_connection_template
    # Get single resource instance cannot be used because its @data may contain new_name
    network = @resourcetype.find_by(@client, unique_id).first
    @bandwidth.each { |key, value| @bandwidth[key] = value.to_i }
    connection_template = OneviewSDK::ConnectionTemplate.find_by(@client, uri: network['connectionTemplateUri']).first
    connection_template_current_bandwidth = connection_template['bandwidth']
    connection_template['bandwidth'] = connection_template['bandwidth'].merge(@bandwidth)
    connection_template.update unless connection_template_current_bandwidth.eql?(connection_template['bandwidth'])
    true
  end
end
