################################################################################
# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
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

Puppet::Type.newtype(:image_streamer_os_volume) do
  desc "Image Streamer's OS Volume"

  # :nocov:
  ensurable do
    newvalue(:found) do
      provider.found
    end

    newvalue(:get_details_archive) do
      provider.get_details_archive
    end

    newvalue(:get_os_volumes_storage) do
      provider.get_os_volumes_storage
    end
  end
  # :nocov:

  newparam(:name, namevar: true) do
    desc 'OS Volume name'
  end

  newparam(:data) do
    desc 'OS Volume data hash containing all specifications for the system'
    validate do |value|
      raise('Inserted value for data is not valid') unless value.respond_to?(:[]) && value.respond_to?(:[]=)
    end
  end
end
