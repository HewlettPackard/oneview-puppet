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

Puppet::Type.type(:oneview_fcoe_network).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Fiber Channel over Ethernet Networks using the C7000 variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def self.resource_name
    'FCoENetwork'
  end

  def exists?
    if resource['data']['networkUris']
      exists_bulk_method
    else
      super
    end
  end

  def create
    # Checks if the operation is an update or bulk_delete
    return true if bulk_delete_check || resource_update
    @resource_type.new(@client, @data).create
  end

  # Bulk deletes networks if there is @data['networkUris']
  def bulk_delete_check
    if @data['networkUris']
      list = []
      @data['networkUris'].each do |item|
        if item.to_s[0..6].include?('/rest/')
          list.push(item)
          next
        end
        net = OneviewSDK.resource_named(:FCoENetwork, api_version, resource_variant).find_by(@client, name: item)
        raise("The network #{name} does not exist.") unless net.first
        list.push(net.first['uri'])
      end
      @data['networkUris'] = list
      @resource_type.bulk_delete(@client, @data)
    else
      false
    end
  end
end
