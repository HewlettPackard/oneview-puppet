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

Puppet::Type.newtype(:oneview_datacenter) do
  desc "Oneview's Datacenter"

  # :nocov:
  ensurable do
    defaultvalues

    # GETs

    newvalue(:found) do
      provider.found
    end

    newvalue(:get_visual_content) do
      provider.get_visual_content
    end
  end

  newparam(:name, namevar: true) do
    desc 'Datacenter name'
  end
  # :nocov:

  newparam(:data) do
    desc 'Datacenter attributes'
    validate do |value|
      raise('Inserted value for data is not valid') unless value.respond_to?(:[]) && value.respond_to?(:[]=)
    end
  end
end
