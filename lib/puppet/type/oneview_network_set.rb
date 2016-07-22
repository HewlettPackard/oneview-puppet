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

require_relative 'common'

Puppet::Type.newtype(:oneview_network_set) do
  desc "Oneview's Network Set"

  # :nocov:
  ensurable do
    defaultvalues

    newvalue(:found) do
      provider.found
    end

    # GETs
    newvalue(:get_network_sets) do
      provider.get_network_sets
    end

    newvalue(:get_without_ethernet) do
      provider.get_without_ethernet
    end

    newvalue(:get_schema) do
      provider.get_schema
    end

    # PUTs
    newvalue(:set_native_network) do
      provider.set_native_network
    end

    newvalue(:add_ethernet_network) do
      provider.add_ethernet_network
    end

    newvalue(:remove_ethernet_network) do
      provider.remove_ethernet_network
    end
  end

  newparam(:name, namevar: true) do
    desc 'Network Set name'
  end
  # :nocov:

  newparam(:data) do
    desc 'Network Set attributes'
    validate do |value|
      unless value.class == Hash
        raise Puppet::Error, 'Inserted value for data is not valid'
      end
      uri_validation(value)
    end
  end
end
