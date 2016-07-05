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

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'login'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_logical_switch_group).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
  end

  def exists?
    return true unless resource['data']
    data = data_parse(resource['data'])
    lsg = OneviewSDK::LogicalSwitchGroup.new(@client, name: data['name'])
    resource_update(data, OneviewSDK::LogicalSwitchGroup) if lsg.retrieve!
    lsg.retrieve!
  end

  def create
    data = data_parse(resource['data'])
    groupingParameters = data['groupingParameters']
    data.delete('groupingParameters') if data['groupingParameters']
    groupingParameters = groupingParameters.to_a
    puts groupingParameters[0][0], groupingParameters[0][1].to_s
    lsg = OneviewSDK::LogicalSwitchGroup.new(@client, data)
    # TO BE FINISHED
    lsg.set_grouping_parameters(groupingParameters[0][0], groupingParameters[0][1].to_s)
    lsg.create!
  end

  def destroy
    data = data_parse(resource['data'])
    data.delete('groupingParameters') if data['groupingParameters']
    lsg = OneviewSDK::LogicalSwitchGroup.new(@client, data)
    lsg.retrieve!
    lsg.delete
  end

  def found
    data = data_parse(resource['data'])
    data.delete('groupingParameters') if data['groupingParameters']
    lsg = OneviewSDK::LogicalSwitchGroup.new(@client, data)
    if lsg.retrieve!
      Puppet.notice("\nLogical Switch Group found in Oneview Appliance "\
      "'#{lsg[:name]}' sucessfully.\n  uri = '#{lsg[:uri]}'")
      true
    end
  end

  def get_logical_switch_groups
    Puppet.notice("\n\nLogical Switch Groups\n")
    lsg_list = OneviewSDK::LogicalSwitchGroup.get_all(@client)
    lsg_list.each do |lsg|
      Puppet.notice("\nLogical Switch Group found in Oneview Appliance"\
      "'#{lsg[:name]}' sucessfully.\n  uri = '#{lsg[:uri]}'")
    end
    true unless lsg_list.empty?
  end

  def get_schema
    Puppet.notice("\n\nLogical Switch Groups Schema\n")
    data = data_parse(resource['data'])
    data.delete('groupingParameters') if data['groupingParameters']
    lsg = OneviewSDK::LogicalSwitchGroup.new(@client, data)
    pretty lsg.schema if lsg.retrieve!
  end
end
