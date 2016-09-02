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

Puppet::Type.type(:oneview_logical_switch_group).provide(:oneview_logical_switch_group) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::LogicalSwitchGroup
    @data = {}
  end

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

  def destroy
    get_single_resource_instance.delete
  end

  def found
    find_resources
  end

  def switch_type_uri
    @data['switchMapTemplate'].each do |key, _|
      @data['switchMapTemplate'][key].each do |item|
        item.each do |uri_key, name|
          next unless uri_key.eql?('permittedSwitchTypeUri') || uri_key.nil? || uri_key.to_s[0..6].include?('/rest/')
          switch_type = OneviewSDK::Switch.get_type(@client, name)
          raise("The switch type #{sub_value} does not exist.") unless switch_type
          item[uri_key] = switch_type['uri']
        end
      end
    end
  end
end
