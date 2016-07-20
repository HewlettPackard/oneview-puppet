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
    @resourcetype = OneviewSDK::LogicalSwitchGroup
    @data = {}
  end

  def exists?
    return true unless resource['data']
    @data = data_parse
    lsg = @resourcetype.new(@client, name: @data['name'])
    if lsg.retrieve! && resource['ensure'] == :present
      resource_update(@data, @resourcetype)
    end
    lsg.exists?
  end

  def create
    switches = resource['switches']
    lsg = @resourcetype.new(@client, @data)
    lsg.set_grouping_parameters(switches['number_of_switches'].to_i, switches['type'].to_s)
    lsg.create!
  end

  def destroy
    lsg = @resourcetype.new(@client, @data)
    lsg.delete if lsg.retrieve!
  end

  def found
    lsg = @resourcetype.new(@client, @data)
    if lsg.retrieve!
      Puppet.notice("\nLogical Switch Group found in Oneview Appliance "\
      "'#{lsg[:name]}' sucessfully.\n  uri = '#{lsg[:uri]}'")
      true
    end
  end

  def get_logical_switch_groups
    Puppet.notice("\n\nLogical Switch Groups\n")
    lsg_list = @resourcetype.get_all(@client)
    lsg_list.each do |lsg|
      Puppet.notice("\nLogical Switch Group found in Oneview Appliance "\
      "'#{lsg[:name]}' sucessfully.\n  uri = '#{lsg[:uri]}'")
    end
    true unless lsg_list.empty?
  end

  def get_schema
    Puppet.notice("\n\nLogical Switch Groups Schema\n")
    lsg = @resourcetype.new(@client, @data)
    lsg.retrieve!
    pretty lsg.schema
    true
  end
end
