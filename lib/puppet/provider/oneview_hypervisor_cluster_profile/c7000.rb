################################################################################
# (C) Copyright 2021 Hewlett Packard Enterprise Development LP
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

  def exists?
    create
  end

  def create
    set_uri
    @data = resource['data']
    return true if resource_update
    super(:create)
  end

  def set_uri
    hm_name = resource['data']['hypervisorManagerUri']
    return if hm_name.to_s[0..6].include?('/rest/')
    hm_uri = OneviewSDK.resource_named(:HypervisorManager, api_version).find_by(@client, name: hm_name).first['uri']
    resource['data']['hypervisorManagerUri'] = hm_uri
    set_spt_uri
  end

  def set_spt_uri
    set_spt_without_dp unless resource['data']['hypervisorHostProfileTemplate'].key?('deploymentPlan')
    set_spt_with_dp if resource['data']['hypervisorHostProfileTemplate'].key?('deploymentPlan')
  end

  def set_spt_without_dp
    spt_class = OneviewSDK.resource_named('ServerProfileTemplate', @client.api_version)
    params = { 'complianceControl' => 'Checked' }
    spt_uri = spt_class.find_by(@client, osDeploymentSettings: params).first['uri']
    resource['data']['hypervisorHostProfileTemplate']['serverProfileTemplateUri'] = spt_uri
  end

  def set_spt_with_dp
    spt_name = resource['data']['hypervisorHostProfileTemplate']['serverProfileTemplateUri']
    return if spt_name.to_s[0..6].include?('/rest/')
    spt_class = OneviewSDK.resource_named('ServerProfileTemplate', @client.api_version)
    resource['data']['hypervisorHostProfileTemplate']['serverProfileTemplateUri'] = spt_class.find_by(@client, name: spt_name).first['uri']
    set_dp
  end

  def set_dp
    dp_class = OneviewSDK.resource_named('OSDeploymentPlan', @client.api_version, 'Synergy')
    dp_name = resource['data']['hypervisorHostProfileTemplate']['deploymentPlan']['deploymentPlanUri']
    return if dp_name.to_s[0..6].include?('/rest/')
    dp_uri = dp_class.find_by(@client, name: dp_name).first['uri']
    resource['data']['hypervisorHostProfileTemplate']['deploymentPlan']['deploymentPlanUri'] = dp_uri
  end

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
