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

Puppet::Type.type(:oneview_volume_template).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Volume Template using the C7000 variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def get_connectable_volume_templates
    query_parameters = @data.delete('query_parameters') || {}
    pretty get_single_resource_instance.get_connectable_volume_templates(query_parameters)
    true
  end

  def get_reachable_volume_templates
    query_parameters = @data.delete('query_parameters') || {}
    svt = OneviewSDK.resource_named('VolumeTemplate', api_version, resource_variant)
    pretty svt.get_reachable_volume_templates(client, query_parameters)
    true
  end

  def get_compatible_systems
    pretty get_single_resource_instance.get_compatible_systems
    true
  end
end
