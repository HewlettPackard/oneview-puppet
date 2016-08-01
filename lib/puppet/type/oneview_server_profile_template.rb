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

Puppet::Type.newtype(:oneview_server_profile_template) do
  desc "Oneview's Server Profile Template"

  ensurable do
    defaultvalues

    # Creating the find operation for the ensure method
    newvalue(:found) do
      provider.found
    end

    # GETs
    newvalue(:get_available_hardware) do
      provider.get_available_hardware
    end

    # PUTs
    newvalue(:set_new_profile) do
      provider.set_new_profile
    end

    newvalue(:set_connection) do
      provider.set_connection
    end

    newvalue(:remove_connection) do
      provider.remove_connection
    end

    newvalue(:set_firmware_driver) do
      provider.set_firmware_driver
    end

    newvalue(:set_enclosure_group) do
      provider.set_enclosure_group
    end

    newvalue(:set_server_hardware_type) do
      provider.set_server_hardware_type
    end
  end

  newparam(:name, namevar: true) do
    desc 'Server Profile Template name'
  end

  newparam(:data) do
    desc 'Server Profile Template data hash containing all specifications for the system'
    validate do |value|
      unless value.class == Hash
        raise Puppet::Error, 'Inserted value for data is not valid'
      end
      uri_validation(value)
    end
  end
end
