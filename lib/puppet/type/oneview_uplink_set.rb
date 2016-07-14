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

Puppet::Type.newtype(:oneview_uplink_set) do
  desc "Oneview's Uplink Set"

  ensurable do
    defaultvalues

    # Creating the find operation for the ensure method
    newvalue(:found) do
      provider.found
    end
  end

  newparam(:name, namevar: true) do
    desc 'Uplink Set name'
  end

  newparam(:data) do
    desc 'Uplink Set data hash containing all specifications for the system'
    validate do |value|
      unless value.class == Hash
        fail Puppet::Error, 'Inserted value for data is not valid'
      end
    end
  end

  newparam(:network) do
    desc 'Accepts network as a name instead of network URI'
  end

  newparam(:fc_network) do
    desc 'Accepts fc_network as a name instead of fc_network URI'
  end

  newparam(:fcoe_network) do
    desc 'Accepts fcoe_network as a name instead of fcoe_network URI'
  end

  newparam(:logical_interconnect) do
    desc 'Accepts logical_interconnect as a name instead of logical_interconnect URI'
  end
end
