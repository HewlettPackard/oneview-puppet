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

Puppet::Type.type(:oneview_server_profile_template).provide(:oneview_server_profile_template) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::ServerProfileTemplate
    @data = {}
  end

  def exists?
    @data = data_parse
    empty_data_check
    connections_parse if @data['connections']
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    return true if resource_update(@data, @resourcetype)
    @resourcetype.new(@client, @data).create
  end

  def destroy
    get_single_resource_instance.delete
  end

  def found
    find_resources
  end

  # Creates a new server profile based on the current template
  def set_new_profile
    server_profile = OneviewSDK::ServerProfile
    # lets the SDK set a default name in case the user has not declared one
    if @data['serverProfileName']
      sp_name = @data.delete('serverProfileName')
      get_single_resource_instance.new_profile(sp_name).create unless server_profile.find_by(@client, name: sp_name).first
    else
      default = 'Server_Profile_created_from_' + @data['name']
      get_single_resource_instance.new_profile.create unless server_profile.find_by(@client, name: default).first
    end
  end
end
