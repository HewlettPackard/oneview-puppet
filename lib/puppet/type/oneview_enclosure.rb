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

Puppet::Type.newtype(:oneview_enclosure) do
  desc "Oneview's Enclosure"

  ensurable do
    defaultvalues

    # Creating the find operation for the ensure method
    newvalue(:found) do
      provider.found
    end

    newvalue(:configured) do
      provider.configured
    end

    newvalue(:retrieved_environmental_configuration) do
      provider.retrieved_environmental_configuration
    end

    newvalue(:set_environmental_configuration) do
      provider.set_environmental_configuration
    end

    newvalue(:set_refresh_state) do
      provider.set_refresh_state
    end

    newvalue(:script_retrieved) do
      provider.script_retrieved
    end

    newvalue(:retrieved_single_sign_on) do
      provider.retrieved_single_sign_on
    end

    newvalue(:retrieved_utilization) do
      provider.retrieved_utilization
    end

  end


  newparam(:name, :namevar => true) do
    desc "Enclosure name"
  end

  newparam(:data) do
    desc "Enclosure data hash containing all specifications for the
    enclosure"
    validate do |value|
      unless value.class == Hash
        raise Puppet::Error, "Inserted value for data is not valid"
      end
    end
  end



end
