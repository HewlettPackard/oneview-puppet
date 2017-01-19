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

Puppet::Type.newtype(:oneview_logical_enclosure) do
  desc "Oneview's Logical Enclosure"

  ensurable do
    defaultvalues

    # :nocov:
    # Get methods
    newvalue(:found) do
      provider.found
    end

    newvalue(:get_script) do
      provider.get_script
    end

    # Set methods
    newvalue(:set_script) do
      provider.set_script
    end

    newvalue(:updated_from_group) do
      provider.updated_from_group
    end

    newvalue(:generate_support_dump) do
      provider.generate_support_dump
    end
    # :nocov:
  end

  newparam(:name, namevar: true) do
    desc 'Logical Enclosure name'
  end

  newparam(:data) do
    desc "Logical Enclosure data hash containing all specifications for the
    network"
    validate do |value|
      raise 'Inserted value for data is not valid' unless value.class == Hash
    end
  end
end
