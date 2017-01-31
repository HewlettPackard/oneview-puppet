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

Puppet::Type::Oneview_logical_downlink.provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Logical Downlinks using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def exists?
    super([nil, :found, :get_without_ethernet])
  end

  def create
    raise('This resource relies on others to be created.')
  end

  def destroy
    raise('This resource relies on others to be destroyed.')
  end

  def get_without_ethernet
    Puppet.notice("\n\nLogical Downlink Without Ethernet\n")
    if @data.empty?
      list = @resourcetype.get_without_ethernet(@client)
      raise('There is no Logical Downlink without ethernet in the Oneview appliance.') if list.empty?
      list.each { |item| pretty item.data }
    else
      list = get_single_resource_instance.get_without_ethernet
      raise('There is no Logical Downlink without ethernet in the Oneview appliance.') unless list
      pretty list.data
    end
    true
  end
end
