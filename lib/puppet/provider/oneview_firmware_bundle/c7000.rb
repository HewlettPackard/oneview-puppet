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

require_relative '../oneview_resource'

Puppet::Type.type(:oneview_firmware_bundle).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Firmware Bundles using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def self.instances
    raise Puppet::Error, 'This resource cannot be queried. Please use the Oneview_firmware_driver provider instead'
  end

  # Provider methods
  def exists?
    @data = data_parse
    raise 'A "firmware_bundle_path" is required for this operation' unless @data['firmware_bundle_path']
  end

  def create
    @resource_type.add(@client, @data['firmware_bundle_path'], @data['timeout'])
  end

  def destroy
    raise '"Absent" is not a valid ensurable for firmware bundle.'
  end

  def found
    raise '"Found" is not a valid ensurable for firmware bundle.'
  end
end
