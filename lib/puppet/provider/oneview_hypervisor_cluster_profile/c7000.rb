################################################################################
# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
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

Puppet::Type.type(:oneview_hypervisor_cluster_profile).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Hypervisor Cluster Profile using the C7000 variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def self.api_version
    1800
  end

  def self.resource_name
    'HypervisorClusterProfile'
  end

  def destroy
    Puppet.info "Data Value: #{@data}"
    force = @data.delete('force') || false
    soft_delete = @data.delete('soft_delete') || false
    hypervisor_cluster_profile = get_single_resource_instance
    if api_version >= 1600
      hypervisor_cluster_profile.delete(soft_delete, force)
    else
      hypervisor_cluster_profile.delete
    end
  end
end
