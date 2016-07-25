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

require 'oneview-sdk'
require File.expand_path(File.join(File.dirname(__FILE__), 'common'))

Puppet::Type.newtype(:oneview_server_hardware_type) do
  desc "Oneview's Server Hardware Type"

  ensurable do
    defaultvalues
    # :nocov:

    # Get Methods
    newvalue(:found) do
      provider.found
    end

    # :nocov:
  end

  newparam(:name, namevar: true) do
    desc 'Logical Server Hardware Type name'
  end

  newparam(:data) do
    desc 'Server Hardware Type data hash containing all specifications for the system'
    validate do |value|
      raise Puppet::Error, 'Inserted value for data is not valid' unless value.class == Hash
      # fail Puppet::Error, 'A data hash parameter is required' unless value
      uri_validation(value)
    end
  end
end
