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

Puppet::Type.newtype(:oneview_power_device) do
  desc "Oneview's Power Device"

  # :nocov:
  ensurable do
    defaultvalues
    newvalue(:found) do
      provider.found
    end

    newvalue(:discover) do
      provider.discover
    end

    newvalue(:set_refresh_state) do
      provider.set_refresh_state
    end

    newvalue(:set_power_state) do
      provider.set_power_state
    end

    newvalue(:set_uid_state) do
      provider.set_uid_state
    end

    newvalue(:get_uid_state) do
      provider.get_uid_state
    end

    newvalue(:get_utilization) do
      provider.get_utilization
    end
  end
  # :nocov:

  newparam(:name, namevar: true) do
    desc 'Power Device name'
  end

  newparam(:data) do
    desc 'Power Device attributes'
    validate do |value|
      unless value.class == Hash
        raise Puppet::Error, 'Inserted value for data is not valid'
      end
    end
  end
end
