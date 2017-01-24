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

Puppet::Type::Oneview_logical_switch_group.provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Fiber Channel Networks using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def exists?
    @data = data_parse
    empty_data_check
    switch_type_uri if @data['switchMapTemplate']
    @switches = @data.delete('switches')
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    new_name = @data.delete('new_name')
    lsg = @resourcetype.new(@client, @data)
    lsg.set_grouping_parameters(@switches['number_of_switches'].to_i, @switches['type'].to_s) if @switches
    @data['new_name'] = new_name if new_name
    return true if resource_update(@data, @resourcetype)
    lsg.create
  end
end
