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

Puppet::Type::Oneview_power_device.provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Power Devices using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  @resourcetype ||= OneviewSDK::PowerDevice

  def initialize(*args)
    @resource_name = 'PowerDevice'
    super(*args)
  end

  def exists?
    @data = data_parse
    empty_data_check([:found, :absent])
    pd_uri_parser
    variable_assignments
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    return true if resource_update(@data, @resourcetype)
    @resourcetype.new(@client, @data).add
  end

  # Remove
  def destroy
    pd = @resourcetype.find_by(@client, @data)
    raise('There were no matching Power Devices in the Appliance.') if pd.empty?
    pd.map(&:remove)
  end

  def found
    find_resources
  end

  def discover
    pd = @resourcetype.discover(@client, @data)
    Puppet.notice("IPDU #{pd['name']} has been discovered!")
  end

  def set_refresh_state
    raise('The refresh options need to be specified in the manifest.') unless @refresh_options
    get_single_resource_instance.set_refresh_state(@refresh_options)
  end

  def set_power_state
    raise('The power state needs to be specified in the manifest.') unless @power_state
    get_single_resource_instance.set_power_state(@power_state)
  end

  def set_uid_state
    raise('The uid state needs to be specified in the manifest.') unless @uid_state
    get_single_resource_instance.set_uid_state(@uid_state)
  end

  def get_uid_state
    Puppet.notice("\n\nPower Device UID State\n")
    pretty get_single_resource_instance.get_uid_state
    true
  end

  def get_utilization
    Puppet.notice("\n\nPower Device Utilization\n")
    @query_parameters ||= {}
    pretty get_single_resource_instance.utilization(@query_parameters)
    true
  end

  # Gets values from @data and deletes them, if they're available
  def variable_assignments
    @refresh_options = @data.delete('refreshOptions') if @data['refreshOptions']
    @power_state = @data.delete('powerState') if @data['powerState']
    @uid_state = @data.delete('uidState') if @data['uidState']
    @query_parameters = @data.delete('queryParameters') if @data['queryParameters']
  end

  # Retrieves the connection uri in case it has not been specified
  def pd_uri_parser
    return unless @data['powerConnections']
    @data['powerConnections'].each do |pc|
      next if pc['connectionUri']
      type = pc.delete('type')
      name = pc.delete('name')
      uri = objectfromstring(type).find_by(@client, name: name)
      raise('The connection uri could not be found in the Appliance.') unless uri.first
      pc['connectionUri'] = uri.first.data['uri']
    end
  end
end
