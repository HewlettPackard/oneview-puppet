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

Puppet::Type.newtype(:oneview_enclosure) do
  desc "Oneview's Enclosure"

  ensurable do
    defaultvalues

    # :nocov:
    # Get methods
    newvalue(:found) do
      provider.found
    end

    newvalue(:get_environmental_configuration) do
      provider.get_environmental_configuration
    end

    newvalue(:get_script) do
      provider.get_script
    end

    newvalue(:get_single_sign_on) do
      provider.get_single_sign_on
    end

    newvalue(:get_utilization) do
      provider.get_utilization
    end

    # Set methods
    newvalue(:set_configuration) do
      provider.set_configuration
    end

    newvalue(:set_environmental_configuration) do
      provider.set_environmental_configuration
    end

    newvalue(:set_refresh_state) do
      provider.set_refresh_state
    end

    newvalue(:create_csr) do
      provider.create_csr
    end

    newvalue(:get_csr) do
      provider.get_csr
    end

    newvalue(:import_csr) do
      provider.import_csr
    end
    # :nocov:
  end

  newparam(:name, namevar: true) do
    desc 'Enclosure name'
  end

  newparam(:data) do
    desc "Enclosure data hash containing all specifications for the
    enclosure"
    validate do |value|
      raise 'Inserted value for data is not valid' unless value.class == Hash
    end
  end
end
