################################################################################
# (C) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
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

Puppet::Type.newtype(:oneview_storage_pool) do
  desc "Oneview's Storage Pool"

  ensurable do
    defaultvalues

    newvalue(:manage) do
      provider.manage
    end

    newvalue(:reachable) do
      provider.reachable
    end

    # :nocov:
    # Get methods
    newvalue(:found) do
      provider.found
    end
    # :nocov:
  end

  newparam(:name, namevar: true) do
    desc 'Storage pool name'
  end

  newparam(:data) do
    desc 'Storage pool data hash containing all specifications for the system'
    validate do |value|
      raise 'Inserted value for data is not valid' unless value.class == Hash
    end
  end
end
