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

Puppet::Type.newtype(:oneview_server_profile) do
  desc "Oneview's Server Profile"

  ensurable do
    defaultvalues

    newvalue(:found) do
      provider.found
    end

    # GETs
    newvalue(:get_available_networks) do
      provider.get_available_networks
    end

    newvalue(:get_available_servers) do
      provider.get_available_servers
    end

    newvalue(:get_available_storage_systems) do
      provider.get_available_storage_systems
    end

    newvalue(:get_available_targets) do
      provider.get_available_targets
    end

    newvalue(:get_profile_ports) do
      provider.get_profile_ports
    end

    newvalue(:get_compliance_preview) do
      provider.get_compliance_preview
    end

    newvalue(:get_messages) do
      provider.get_messages
    end

    newvalue(:get_transformation) do
      provider.get_transformation
    end
  end

  newparam(:name, namevar: true) do
    desc 'Server Profile name'
  end

  newparam(:data) do
    desc 'Server Profile data hash containing all specifications for the system'
    validate do |value|
      raise('Inserted value for data is not valid') unless value.class == Hash
      uri_validation(value)
    end
  end
end
