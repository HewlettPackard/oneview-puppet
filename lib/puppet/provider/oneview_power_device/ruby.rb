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

Puppet::Type.type(:oneview_power_device).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::PowerDevice
    @data = {}
  end

  def exists?
    @data = data_parse
    pd = if resource['ensure'] == :present
           resource_update(@data, @resourcetype)
           @resourcetype.find_by(@client, unique_id)
         else
           @resourcetype.find_by(@client, @data)
         end
    !pd.empty?
  end

  def create
    empty_data_check
    @resourcetype.new(@client, @data).add
  end

  # Remove
  def destroy
    empty_data_check
    pd = @resourcetype.find_by(@client, @data)
    raise('There were no matching Power Devices in the Appliance.') if pd.empty?
    pd.map(&:remove)
  end

  def found
    find_resources
  end

  def discover
    empty_data_check
    pd = @resourcetype.discover(@client, @data)
    Puppet.notice("IPDU #{pd['name']} has been discovered!")
  end

  def set_refresh_state
    empty_data_check
    pd = @resourcetype.find_by(@client, unique_id)
    pd.first.set_refresh_state(@data['refreshOptions'])
  end

  def set_power_state
    empty_data_check
    pd = @resourcetype.find_by(@client, unique_id)
    pd.first.set_power_state(@data['powerState'])
  end

  def set_uid_state
    empty_data_check
    pd = @resourcetype.find_by(@client, unique_id)
    pd.first.set_uid_state(@data['uidState'])
  end

  def get_uid_state
    empty_data_check
    pd = @resourcetype.find_by(@client, unique_id)
    pretty pd.first.get_uid_state
  end

  def get_utilization
    empty_data_check
    pd = @resourcetype.find_by(@client, unique_id)
    parameters = if @data['queryParameters']
                   @data['queryParameters']
                 else
                   {}
                 end
    pretty pd.first.utilization(parameters)
  end

  # Helper

  def empty_data_check
    raise('There is no data provided in the manifest.') if @data == {}
  end
end
