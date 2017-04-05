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

Puppet::Type.type(:oneview_connection_template).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Connection Templates using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def exists?
    super([nil, :found, :get_default_connection_template])
  end

  def create
    super(:update)
  end

  def get_default_connection_template
    Puppet.notice "\n\nDefault Connection Template:"
    default = @resource_type.get_default(@client)
    return true unless default['uri']
    Puppet.notice "\nName: '#{default['name']}'"
    Puppet.notice "(- maximumBandwidth: #{default['bandwidth']['maximumBandwidth']})"
    Puppet.notice "(- typicalBandwidth: #{default['bandwidth']['typicalBandwidth']})\n\n"
  end
end
