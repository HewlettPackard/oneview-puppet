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

Puppet::Type.type(:oneview_datacenter).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Datacenters using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def exists?
    prepare_environment
    return @resource_type.find_by(@client, @data).any? if resource['ensure'].to_sym == :absent
    super([nil, :found, :absent])
  end

  def create
    super(:add)
  end

  # This method deletes all the datacenters that match the data passed in. Use with caution.
  def destroy
    super(:multiple_remove)
  end

  def get_visual_content
    Puppet.notice("\n\nDatacenter Visual Content\n")
    pretty get_single_resource_instance.get_visual_content
    true
  end
end
