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

Puppet::Type.newtype(:oneview_server_hardware) do
  desc "Oneview's Server Hardware"

  ensurable do
    defaultvalues
    # :nocov:
    # Get Methods
    newvalue(:found) do
      provider.found
    end

    newvalue(:get_bios) do
      provider.get_bios
    end

    newvalue(:get_ilo_sso_url) do
      provider.get_ilo_sso_url
    end

    newvalue(:get_java_remote_sso_url) do
      provider.get_java_remote_sso_url
    end

    newvalue(:get_remote_console_url) do
      provider.get_remote_console_url
    end

    newvalue(:get_environmental_configuration) do
      provider.get_environmental_configuration
    end

    newvalue(:get_utilization) do
      provider.get_utilization
    end

    # Set methods

    newvalue(:update_ilo_firmware) do
      provider.update_ilo_firmware
    end

    newvalue(:set_refresh_state) do
      provider.set_refresh_state
    end

    newvalue(:set_power_state) do
      provider.set_power_state
    end
    # :nocov:
  end

  newparam(:name, namevar: true) do
    desc 'Logical Server Hardware name'
  end

  newparam(:data) do
    desc 'Server Hardware data hash containing all specifications for the system'
    validate do |value|
      raise Puppet::Error, 'Inserted value for data is not valid' unless value.class == Hash
    end
  end
end
