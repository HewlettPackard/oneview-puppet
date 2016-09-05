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

Puppet::Type.newtype(:oneview_logical_switch) do
  desc "Oneview's Logical Switch"

  # :nocov:
  ensurable do
    defaultvalues

    # Creating the find operation for the ensure method
    newvalue(:found) do
      provider.found
    end

    newvalue(:refresh) do
      provider.refresh
    end
  end
  # :nocov:

  newparam(:name, namevar: true) do
    desc 'Logical Switch name'
  end

  newparam(:data) do
    desc 'Logical Switch attributes'
    validate do |value|
      raise('Inserted value for data is not valid') unless value.class == Hash
    end
  end
end
