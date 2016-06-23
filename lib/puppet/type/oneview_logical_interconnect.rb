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

Puppet::Type.newtype(:oneview_logical_interconnect) do
  desc "Oneview's Logical Interconnect"

  ensurable do

    defaultvalues

    newvalue(:found) do
      provider.found
    end

    newvalue(:get_ethernet_settings) do
      provider.get_ethernet_settings
    end

    newvalue(:set_qos_aggregated_configuration) do
      provider.set_qos_aggregated_configuration
    end

    newvalue(:get_qos_aggregated_configuration) do
      provider.get_qos_aggregated_configuration
    end

    newvalue(:get_snmp_configuration) do
      provider.get_snmp_configuration
    end

  end

  newparam(:name, :namevar => true) do
    desc "FCoE network name"
  end

  newparam(:data) do
    desc "Logical Interconnect data hash containing all specifications for the
    resource"
    validate do |value|
      unless value.class == Hash
        raise Puppet::Error, "Inserted value for data is not valid"
      end
    end
  end

end
