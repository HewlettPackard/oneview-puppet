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

Puppet::Type.newtype(:oneview_sas_logical_interconnect) do
  desc "Oneview's SAS Logical Interconnect"

  #:nocov:
  ensurable do
    defaultvalues

    newvalue(:found) do
      provider.found
    end

    newvalue(:get_firmware) do
      provider.get_firmware
    end

    newvalue(:set_configuration) do
      provider.set_configuration
    end

    newvalue(:set_firmware) do
      provider.set_firmware
    end

    newvalue(:set_compliance) do
      provider.set_compliance
    end

    newvalue(:replace_drive_enclosure) do
      provider.replace_drive_enclosure
    end
  end
  #:nocov:

  newparam(:name, namevar: true) do
    desc 'SAS Logical interconnect process name'
  end

  newparam(:data) do
    desc 'SAS Logical Interconnect data hash containing all specifications for the resource'
    validate do |value|
      raise('Inserted value for data is not valid') unless value.class == Hash
    end
  end
end
