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

Puppet::Type.type(:oneview_storage_system).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Storage Systems using the C7000 variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def exists?
    super([nil, :found, :get_host_types])
  end

  def create
    super(:add)
  end

  def destroy
    super(:remove)
  end

  def get_storage_pools
    storage_system = get_single_resource_instance
    Puppet.notice "\nStorage System #{storage_system['name']} storage pools:\n"
    pretty storage_system.get_storage_pools
    true
  end

  def get_managed_ports
    ports ||= @data.delete('ports')
    storage_system = get_single_resource_instance
    Puppet.notice "\nRetrieving managed ports from storage system #{storage_system['name']}...\n"
    pretty storage_system.get_managed_ports(ports)
    true
  end

  def get_host_types
    pretty @resource_type.get_host_types(@client)
    true
  end
end
