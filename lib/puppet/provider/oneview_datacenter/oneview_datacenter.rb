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

Puppet::Type.type(:oneview_datacenter).provide(:oneview_datacenter) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::Datacenter
    @data = {}
  end

  def exists?
    @data = data_parse
    empty_data_check([:found, :destroy])
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    return true if resource_update(@data, @resourcetype)
    @resourcetype.new(@client, @data).add
  end

  def destroy
    datacenter = @resourcetype.find_by(@client, @data)
    raise('There were no matching Datacenters in the Appliance.') if datacenter.empty?
    datacenter.map(&:remove)
  end

  def found
    find_resources
  end

  def get_visual_content
    Puppet.notice("\n\nDatacenter Visual Content\n")
    pretty get_single_resource_instance.get_visual_content
    true
  end
end
