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

Puppet::Type.type(:oneview_server_profile).provide(:oneview_server_profile) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::ServerProfile
    @data = {}
  end

  def exists?
    @data = data_parse
    empty_data_check([:found, :get_available_targets, :get_available_networks])
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    return true if resource_update(@data, @resourcetype)
    @resourcetype.new(@client, @data).create
  end

  def destroy
    server_profiles = @resourcetype.find_by(@client, @data)
    raise('There were no matching server profiles in the Appliance.') if server_profiles.empty?
    server_profiles.map(&:delete)
  end

  def get_available_networks
    Puppet.notice("\n\nServer Profile Available Networks\n")
    pretty get_single_resource_instance.get_available_networks
    true
  end

  def get_available_servers
    Puppet.notice("\n\nServer Profile Template Available Targets\n")
    pretty @resourcetype.get_available_targets(@client)['targets']
    true
  end

  def get_available_storage_systems
    Puppet.notice("\n\nServer Profile Template Available Targets\n")
    pretty @resourcetype.get_available_targets(@client)['targets']
    true
  end

  def get_available_targets
    Puppet.notice("\n\nServer Profile Template Available Targets\n")
    pretty @resourcetype.get_available_targets(@client)['targets']
    true
  end

  def get_profile_ports
  end

  def get_compliance_preview
  end

  def get_messages
  end

  def get_transformation
  end

  # Helpers

  def getters
    Puppet.notice("\n\nServer Profile #{notice}\n")
    get_single_resource_instance
  end
end
