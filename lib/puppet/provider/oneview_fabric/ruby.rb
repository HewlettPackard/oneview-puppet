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

Puppet::Type.type(:oneview_fabric).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::Fabric
    @data = {}
  end

  def exists?
    return false unless resource['data']
    @data = data_parse
    @id = unique_id
    fabric = @resourcetype.find_by(@client, @id)
    return false unless fabric.first
    # The fabric update is currently unavailable, although it should be possible as the API Reference says
    # resource_update(@data, @resourcetype)
    true
  end

  def create
    raise('This resource cannot be created.')
  end

  def destroy
    raise('This resource cannot be destroyed.')
  end

  def found
    find_resources
  end

  def get_reserved_vlan_range
    raise('There is no data provided in the manifest.') if @data == {}
    Puppet.notice("\n\nFabric Reserved Vlan Range")
    fabric = get_single_resource_instance
    range = fabric.data['reservedVlanRange']
    puts "\n- The Vlan IDs range from #{range['start']} to #{range['length'].to_i + range['start'].to_i}\
          \n#{pretty range}\n"
    true
  end
end
