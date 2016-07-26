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

Puppet::Type.type(:oneview_datacenter).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::Datacenter
    @data = {}
  end

  def exists?
    return false unless resource['data']
    @data = data_parse
    @id = unique_id
    dc = @resourcetype.find_by(@client, @id)
    return false unless dc.first
    resource_update(@data, @resourcetype)
    true
  end

  def create
    raise('There is no data provided in the manifest.') if @data == {}
    @resourcetype.new(@client, @data).add
  end

  def destroy
    raise('There is no data provided in the manifest.') if @data == {}
    @resourcetype.find_by(@client, @id).first.remove
  end

  def found
    found_general
  end

  def get_schema
    schema_general('Datacenter')
  end

  def get_datacenters
    find_resources
  end

  def get_visual_content
    Puppet.notice("\n\nDatacenter Visual Content\n")
    dc = @resourcetype.find_by(@client, @id).first
    raise('The Datacenter has not been found.') unless dc
    pretty dc.get_visual_content
    true
  end
end
