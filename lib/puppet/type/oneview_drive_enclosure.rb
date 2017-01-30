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

Puppet::Type.newtype(:oneview_drive_enclosure) do
  desc "OneView's Drive Enclosure"

  ensurable do
    defaultvalues

    # :nocov:
    # Get methods
    newvalue(:found) do
      provider.found
    end

    newvalue(:set_refresh_state) do
      provider.set_refresh_state
    end
    # :nocov:
  end

  newparam(:name, namevar: true) do
    desc 'Drive Enclosure name'
  end

  newparam(:data) do
    desc "Drive Enclosure data hash containing all specifications for the
    enclosure"
    validate do |value|
      raise 'Inserted value for data is not valid' unless value.class == Hash
    end
  end
end
