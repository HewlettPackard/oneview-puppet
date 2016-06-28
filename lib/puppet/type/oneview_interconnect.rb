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

Puppet::Type.newtype(:oneview_interconnect) do
  desc "Oneview's Interconnect"

  ensurable do
    defaultvalues

    # Creating the find operation for the ensure method
    newvalue(:found) do
      provider.found
    end

    # GETs
    newvalue(:get_interconnect_type) do
      provider.get_interconnect_type
    end

    newvalue(:get_schema) do
      provider.get_schema
    end

    newvalue(:get_statistics) do
      provider.get_statistics
    end

    newvalue(:get_subport_statistics) do
      provider.get_subport_statistics
    end

    newvalue(:get_name_servers) do
      provider.get_name_servers
    end

    newvalue(:get_types) do
      provider.get_types
    end

    # PUTs

    newvalue(:reset_port_protection) do
      provider.reset_port_protection
    end

    newvalue(:update_ports) do
      provider.update_ports
    end

  end


  newparam(:name, :namevar => true) do
    desc "Interconnect name"
  end

  newparam(:data) do
    desc "Interconnect data hash containing all specifications for the
    resource"
    validate do |value|
        raise Puppet::Error, "Inserted value for data is not valid" unless value.class == Hash
    end
  end

end
