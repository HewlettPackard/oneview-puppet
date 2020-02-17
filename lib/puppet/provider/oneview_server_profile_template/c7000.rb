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
require 'oneview-sdk'

Puppet::Type.type(:oneview_server_profile_template).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Server Profile Templates using the C7000 variant of the OneView API'
  mk_resource_methods

  def exists?
    prepare_environment
    empty_data_check
    connections_parse if @data['connectionSettings']
    !@resource_type.find_by(@client, @data).empty?
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

  def get_transformation
    Puppet.notice("\n\nServer Profile Template Transformation\n")
    parameters = @data.delete('queryParameters') || {}
    pretty get_single_resource_instance.get_transformation(@client, parameters)
    true
  end

  def get_available_networks
    Puppet.notice("\n\nServer Profile Template Available Networks\n")
    parameters = @data.delete('queryParameters') || {}
    pretty get_single_resource_instance.get_available_networks(@client, parameters)
    true
  end
end
