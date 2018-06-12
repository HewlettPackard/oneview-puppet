################################################################################
# (C) Copyright 2018 Hewlett Packard Enterprise Development LP
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

Puppet::Type.type(:oneview_os_deployment_plan).provide :synergy, parent: Puppet::OneviewResource do
  desc 'Provider for OneView OS Deployment Plans using the Synergy variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'Synergy'

  mk_resource_methods

  def self.resource_name
    'OSDeploymentPlan'
  end
end
