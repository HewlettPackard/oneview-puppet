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

Puppet::Type.newtype(:oneview_volume_attachment) do
  desc "Oneview's Volume Attachment"

  ensurable do
    defaultvalues

    # :nocov:
    # Get methods
    newvalue(:found) do
      provider.found
    end

    newvalue(:get_extra_unmanaged_volumes) do
      provider.get_extra_unmanaged_volumes
    end

    newvalue(:get_paths) do
      provider.get_paths
    end

    # Set methods
    newvalue(:remove_extra_unmanaged_volume) do
      provider.remove_extra_unmanaged_volume
    end
    # :nocov:
  end

  newparam(:name, namevar: true) do
    desc 'Volume Attachment name'
  end

  newparam(:data) do
    desc 'Volume Attachment data hash containing all specifications for the system'
    validate do |value|
      raise 'Inserted value for data is not valid' unless value.class == Hash
    end
  end
end
