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

Puppet::Type::Oneview_storage_pool.provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Storage Pools using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  # Provider methods
  def exists?
    super
    # Allows find_by to work in case poolName is declared, since find_by returns it as 'name'
    @data['name'] = @data.delete('poolName') if @data['poolName']
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    raise 'A "poolName" or "name" tag is required within data for this operation' unless @data['name']
    return unless setup_for_recreation
    # Changes name into poolName which is required only for creation
    @data['poolName'] = @data.delete('name') if @data['name']
    super(:add)
  end

  def destroy
    super(:remove)
  end

  def setup_for_recreation
    storage_pool = @resourcetype.find_by(@client, name: @data['name'])
    return true if storage_pool.empty?
    storage_pool.first.remove
    true
  end
end
