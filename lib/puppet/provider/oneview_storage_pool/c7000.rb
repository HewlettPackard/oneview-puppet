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

Puppet::Type.type(:oneview_storage_pool).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Storage Pools using the C7000 variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def data_parse
    @data['name'] = @data.delete('poolName') if @data['poolName']
  end

  def create
    raise 'A "poolName" or "name" tag is required within data for this operation' unless @data['name']
    return unless setup_for_recreation
    # Changes name into poolName which is required only for creation
    @data['poolName'] = @data.delete('name') if @data['name']
    super(:add)
  end

  def manage
    return unless @client.api_version >= 500
    is_managed = @data.delete('isManaged')
    set_storage_system
    get_single_resource_instance.manage(is_managed)
    true
  end

  def reachable
    return unless @client.api_version >= 500
    @data['uri'] = OneviewSDK.resource_named('StoragePool', api_version).find_by(@client, name: @data['uri']).first['uri']
    pretty @resource_type.reachable(@client)
    true
  end

  def destroy
    super(:remove)
  end

  # TODO: Swap this out for a simple message that the resource differs and should be dropped/recreated.
  # Too dangerous to be trying to drop and recreate without explicitly being told that we want to do that.
  # Option 2 = use a 'force' tag.
  def setup_for_recreation
    storage_pool = @resource_type.find_by(@client, name: @data['name'])
    return true if storage_pool.empty?
    storage_pool.first.remove
    true
  end
  
  def set_storage_system
    storage_system = @data['storageSystemUri']
    storage_system_class = OneviewSDK.resource_named('StorageSystem', @client.api_version)
    uri = storage_system_class.find_by(@client, name: storage_system).first['uri']
    @data['storageSystemUri'] = uri
  end
end
