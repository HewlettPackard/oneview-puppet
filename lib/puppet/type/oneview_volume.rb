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

Puppet::Type.newtype(:oneview_volume) do
  desc "Oneview's Volume"

  ensurable do
    defaultvalues

    # :nocov:
    # Get methods
    newvalue(:found) do
      provider.found
    end

    newvalue(:get_attachable_volumes) do
      provider.get_attachable_volumes
    end

    newvalue(:get_extra_managed_volume_paths) do
      provider.get_extra_managed_volume_paths
    end

    newvalue(:get_snapshot) do
      provider.get_snapshot
    end

    # SET/POST/PUT/DELETE methods
    newvalue(:repair) do
      provider.repair
    end

    newvalue(:create_snapshot) do
      provider.create_snapshot
    end

    newvalue(:delete_snapshot) do
      provider.delete_snapshot
    end
    # :nocov:
  end

  newparam(:name, namevar: true) do
    desc 'Volume name'
  end

  newparam(:data) do
    desc 'Volume data hash containing all specifications for the system'
    validate do |value|
      raise 'Inserted value for data is not valid' unless value.class == Hash
      uri_validation(value)
    end
  end
end
