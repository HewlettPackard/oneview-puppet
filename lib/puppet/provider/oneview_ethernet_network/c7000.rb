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

Puppet::Type.type(:oneview_ethernet_network).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Ethernet Networks using the C7000 variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def exists?
    if resource['data']['networkUris'] || resource['data']['vlanIdRange']
      exists_bulk_method
    else
      super
      @bandwidth = @data.delete('bandwidth')
      @resource_type.find_by(@client, @data).any?
    end
  end

  def create
    # Checks if there is a connection template update
    update_connection_template if @bandwidth
    # Checks if the operation is an update, bulk create, bulk_delete
    return true if bulk_delete_check || bulk_create_check || resource_update
    @resource_type.new(@client, @data).create
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

  # Helpersmiss

  # Creates bulk networks if there is @data['vlanIdRange']
  def bulk_create_check
    if @data['vlanIdRange']
      Puppet.warning 'Deprecation warning! Bulk creation cannot be correctly maintained with idempotency,
       so it will be discontinued in future releases. Adopt the single resource style creation in the future.'
      @resource_type.bulk_create(@client, bulk_parse(@data))
    else
      false
    end
  end

  # Bulk deletes networks if there is @data['networkUris']
  def bulk_delete_check
    if @data['networkUris']
      set_network_uris
      @resource_type.bulk_delete(@client, @data)
    else
      false
    end
  end

  def bulk_parse(data)
    data = Hash[data.map { |k, v| [k.to_sym, v] }]
    data[:bandwidth] = Hash[data[:bandwidth].map { |k, v| [k.to_sym, v.to_i] }]
    data
  end

  # Checks whether the connection template needs to be updated
  def update_connection_template
    # Get single resource instance cannot be used because its @data may contain new_name
    network = @resource_type.find_by(@client, unique_id).first
    @bandwidth.each { |key, value| @bandwidth[key] = value.to_i }
    connection_template = OneviewSDK::ConnectionTemplate.find_by(@client, uri: network['connectionTemplateUri']).first
    connection_template_current_bandwidth = connection_template['bandwidth']
    connection_template['bandwidth'] = connection_template['bandwidth'].merge(@bandwidth)
    connection_template.update unless connection_template_current_bandwidth.eql?(connection_template['bandwidth'])
    true
  end

  def set_network_uris
    return unless @data['networkUris'].present?
    network_class = OneviewSDK.resource_named('EthernetNetwork', @client.api_version)
    options = {
      vlanId:  '1001',
      purpose:  'General',
      name:  'EtherNetwork_Test1',
      smartLink:  false,
      privateNetwork:  false,
      connectionTemplateUri: nil
    }
    network_one = network_class.new(@client, options)
    network_one.create!

    options['name'] = 'EtherNetwork_Test2'
    network_two = network_class.new(@client, options)
    network_two.create!
    @data['networkUris'] = [network_one['uri'], network_two['uri']]
  end
end
