################################################################################
# (C) Copyright 2017-2020 Hewlett Packard Enterprise Development LP
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

Puppet::Type.type(:oneview_logical_interconnect_group).provide :synergy, parent: :c7000 do
  desc 'Provider for OneView Fiber Channel Networks using the Synergy variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'Synergy'

  def parse_interconnects
    lig = OneviewSDK.resource_named(:LogicalInterconnectGroup, login[:api_version], 'Synergy').new(@client, {})
    @interconnects.each do |item|
      item['enclosure_index'] ||= 1
      lig.add_interconnect(item['bay'].to_i, item['type'], item['logical_downlink'], item['enclosure_index'])
    end
    lig['interconnectMapTemplate']
  end
end