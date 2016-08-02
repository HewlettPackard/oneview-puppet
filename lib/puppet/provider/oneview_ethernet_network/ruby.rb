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

Puppet::Type.type(:oneview_ethernet_network).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::EthernetNetwork
    @data = {}
  end

  def exists?
    @data = data_parse
    # Skips to bulk
    return false if @data['vlanIdRange']
    en = if resource['ensure'] == :present
           resource_update(@data, @resourcetype)
           @resourcetype.find_by(@client, unique_id)
         else
           @resourcetype.find_by(@client, @data)
         end
    !en.empty?
  end

  def create
    @data = data_parse
    # Bulk
    if @data['vlanIdRange']
      @resourcetype.bulk_create(@client, bulk_parse(@data))
    else
      ethernet_network = @resourcetype.new(@client, @data)
      ethernet_network.create
    end
  end

  def destroy
    ethernet_network = @resourcetype.find_by(@client, unique_id)
    ethernet_network.first.delete
    @property_hash.clear
  end

  def found
    find_resources
  end

  def bulk_parse(data)
    data = Hash[data.map { |k, v| [k.to_sym, v] }]
    data[:bandwidth] = Hash[data[:bandwidth].map { |k, v| [k.to_sym, v.to_i] }]
    data
  end
end
