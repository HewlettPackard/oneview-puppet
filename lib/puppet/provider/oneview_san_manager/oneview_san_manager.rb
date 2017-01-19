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

require_relative '../login'
require_relative '../common'
require 'oneview-sdk'

Puppet::Type.type(:oneview_san_manager).provide(:oneview_san_manager) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::SANManager
    # Initializes the data so it is parsed only on exists and accessible throughout the methods
    # This is not set here due to the 'resources' variable not being accessible in initialize
    @data = {}
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::SANManager.get_all(@client)
    matches.collect do |line|
      name = line['name']
      data = line.data
      new(name: name,
          ensure: :present,
          data: data)
    end
  end

  # Provider methods
  def exists?
    @data = data_parse
    parse_provider_uri
    pretty @data
    empty_data_check
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    return true if resource_update(@data, @resourcetype)
    @resourcetype.new(@client, @data).add
    @property_hash[:ensure] = :present
    @property_hash[:data] = @data
    true
  end

  def destroy
    san_manager = get_single_resource_instance
    Puppet.notice "\n\n Removing san_manager named: #{san_manager['name']}, with uri: #{san_manager['uri']}\n"
    san_manager.remove
    @property_hash.clear
  end

  def found
    find_resources
  end

  def parse_provider_uri
    return unless @data['providerUri']
    return if @data['providerUri'].to_s[0..6].include?('/rest/')
    @data['providerDisplayName'] = @data.delete('providerUri')
  end
end
