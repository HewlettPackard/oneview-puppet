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

Puppet::Type.type(:oneview_rack).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::Rack
    # Initializes the data so it is parsed only on exists and accessible throughout the methods
    # This is not set here due to the 'resources' variable not being accessible in initialize
    @data = {}
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::Rack.get_all(@client)
    matches.collect do |line|
      name = line['name']
      data = line.inspect
      new(name: name,
          ensure: :present,
          data: data)
    end
  end

  # Provider methods

  def exists?
    @data = data_parse
    rack = @resourcetype.find_by(@client, @data)
    !rack.empty?
  end

  def create
    return true if resource_update(@data, @resourcetype)
    @resourcetype.new(@client, @data).add
    @property_hash[:ensure] = :present
    @property_hash[:data] = @data
    true
  end

  def destroy
    racks = @resourcetype.find_by(@client, @data)
    raise 'No racks matching the specified data were found' if racks.empty?
    racks.each do |rack|
      Puppet.notice "\n\n Removing rack named: #{rack['name']}, with uri: #{rack['uri']}\n"
      rack.remove
      @property_hash.clear
    end
  end

  def found
    find_resources
  end

  # def data_parse_for_general
  #   @data['name'] = @data.delete('customBaselineName') if @data['customBaselineName']
  #   @data.each do |key, _value|
  #     case key
  #     when 'baselineUri' then
  #       @attributes['baselineUri'] = @data.delete('baselineUri')
  #       parse_uris_for_rack('baselineUri', @attributes['baselineUri'])
  #     when 'hotfixUris' then
  #       @attributes['hotfixUris'] = @data.delete('hotfixUris')
  #       parse_uris_for_rack('hotfixUris', @attributes['hotfixUris'])
  #     end
  #   end
  # end
  #
  # def parse_uris_for_rack(key, value, extra = nil)
  #   if value.is_a? Array
  #     value.each_with_index do |array_value, array_key|
  #       parse_uris_for_rack(key, array_value, array_key)
  #       return true
  #     end
  #   end
  #   return if value.to_s[0..6].include?('/rest/')
  #   rack = @resourcetype.find_by(@client, name: value)
  #   raise "No #{key}s found on the appliance matching the provided name #{value}. Provide a valid name or uri." if rack.empty?
  #   if extra
  #     @attributes[key][extra] = rack.first['uri']
  #   else
  #     @attributes[key] = rack.first['uri']
  #   end
  # end
end
