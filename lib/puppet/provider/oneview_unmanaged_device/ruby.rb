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

Puppet::Type.type(:oneview_unmanaged_device).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::UnmanagedDevice
    @data = {}
  end

  def exists?
    @data = data_parse
    empty_data_check
    ud = if resource['ensure'] == :present
           resource_update(@data, @resourcetype)
           @resourcetype.find_by(@client, unique_id)
         else
           @resourcetype.find_by(@client, @data)
         end
    !ud.empty?
  end

  def create
    @resourcetype.new(@client, @data).add
  end

  def destroy
    @resourcetype.find_by(@client, unique_id).first.remove
  end

  def found
    find_resources
  end

  def get_environmental_configuration
    resource = @resourcetype.find_by(@data, unique_id)
    raise('There were no matching Unmanaged Devices in the Appliance.') unless resource.first
    resource.first.get_environmental_configuration
  end

  def empty_data_check
    raise('There is no data provided in the manifest.') if @data.empty? && resource['ensure'] != :found
  end
end
