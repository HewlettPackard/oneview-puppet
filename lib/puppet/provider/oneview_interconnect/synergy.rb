################################################################################
# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
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

Puppet::Type.type(:oneview_interconnect).provide :synergy, parent: :c7000 do
  desc 'Provider for OneView Interconnects using the Synergy variant of the OneView API'

  confine true: login[:hardware_variant] == 'Synergy'
  defaultfor oneview_synergy_variant: 'Synergy'

  def get_link_topologies
    Puppet.notice("\n\nInterconnect link topologies:\n")
    if @data['name']
      pretty @resource_type.get_link_topology(@client, @data['name'])
    else
      pretty @resource_type.get_link_topologies(@client)
    end
    true
  end
end
