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

Puppet::Type.newtype(:image_streamer_plan_script) do
  desc "Image Streamer's Plan Script"

  # :nocov:
  ensurable do
    defaultvalues

    newvalue(:found) do
      provider.found
    end

    newvalue(:retrieve_differences) do
      provider.retrieve_differences
    end

    newvalue(:retrieve_read_only) do
      provider.retrieve_read_only
    end
  end
  # :nocov:

  newparam(:name, namevar: true) do
    desc 'Plan Script name'
  end

  newparam(:data) do
    desc 'Plan Script data hash containing all specifications for the system'
    validate do |value|
      raise('Inserted value for data is not valid') unless value.respond_to?(:[]) && value.respond_to?(:[]=)
    end
  end
end
