################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
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

# ============== Ethernet Network methods ==============
# Returns the result of a network search by name
def get_ethernet_network(name)
  matches = OneviewSDK::EthernetNetwork.find_by(@client, name: name)
  return matches
end

# Returns the result of a network search using all data provided
def find_ethernet_networks(data)
  matches = OneviewSDK::EthernetNetwork.find_by(@client, data)
  return matches
end

def ethernet_network_update(data, ethernet_network, process)
  data['name'] = data['new_name'] if data['new_name']
  data.delete('connectionTemplateUri') if data['connectionTemplateUri'] == nil
  raw_merged_data = ethernet_network.data.merge(data)
  updated_data = Hash[raw_merged_data.to_a-ethernet_network.data.to_a]
  if updated_data.size > 0
    updated_data.delete('new_name') if updated_data['new_name']
    ethernet_network.update(updated_data)
    Puppet.notice("#{process} updated: #{updated_data.inspect} ")
  end
end

def bulk_parse(data)
  data = Hash[data.map{ |k, v| [k.to_sym, v] }]
  data[:bandwidth] = Hash[data[:bandwidth].map{ |k, v| [k.to_sym, v.to_i] }]
  data
end
