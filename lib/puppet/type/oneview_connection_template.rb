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

Puppet::Type.newtype(:oneview_connection_template) do
  desc "Oneview's Connection Template"

  # :nocov:
  ensurable do
    defaultvalues

    newvalue(:found) do
      provider.found
    end

    # GETs
    newvalue(:get_connection_templates) do
      provider.get_connection_templates
    end

    newvalue(:get_default_connection_template) do
      provider.get_default_connection_template
    end

    newvalue(:get_schema) do
      provider.get_schema
    end
  end

  newparam(:name, namevar: true) do
    desc 'Connection Template name'
  end
  # :nocov:

  newparam(:data) do
    desc 'Connection Template attributes'
    validate do |value|
      unless value.class == Hash
        raise Puppet::Error, 'Inserted value for data is not valid'
      end
      uri_validation(value)
    end
  end
end
