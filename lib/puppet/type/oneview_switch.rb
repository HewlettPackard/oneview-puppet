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

Puppet::Type.newtype(:oneview_switch) do
  desc "Oneview's Switch"

  ensurable do
    defaultvalues

    # Starting to ignore the provider methods in simplecov, since they won't be accessed in the file itself
    # :nocov:
    # Creating the find operation for the ensure method
    newvalue(:found) do
      provider.found
    end

    newvalue(:get_type) do
      provider.get_type
    end

    newvalue(:get_statistics) do
      provider.get_statistics
    end

    newvalue(:get_environmental_configuration) do
      provider.get_environmental_configuration
    end

    newvalue(:set_scope_uris) do
      provider.set_scope_uris
    end
    # :nocov:
  end

  newparam(:name, namevar: true) do
    desc 'Switch name'
  end

  newparam(:data) do
    desc 'Switch data hash containing all specifications for the system'
    validate do |value|
      raise Puppet::Error('Inserted value for data is not valid') unless value.class == Hash
    end
  end
end
