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

Puppet::Type.type(:oneview_logical_interconnect_group).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::LogicalInterconnectGroup
    @data = {}
  end

  def exists?
    @data = data_parse
    lig = if resource['ensure'] == :present
            resource_update(@data, @resourcetype)
            @resourcetype.find_by(@client, unique_id)
          else
            @resourcetype.find_by(@client, @data)
          end
    !lig.empty?
  end

  def found
    find_resources
  end

  def create
    lig = @resourcetype.new(@client, @data)
    lig.create
  end

  def destroy
    lig = @resourcetype.find_by(@client, unique_id)
    lig.first.delete
  end

  def get_settings
    Puppet.notice("\n\nLogical Interconnect Group Settings\n")
    lig = @resourcetype.find_by(@client, unique_id)
    if lig.first
      pretty lig.first.get_settings
      true
    else
      Puppet.warning('No Logical Interconnect Groups with the given specifications were found.')
      false
    end
  end

  def get_default_settings
    Puppet.notice("\n\nLogical Interconnect Group Default Settings\n")
    lig = @resourcetype.find_by(@client, unique_id)
    if lig.first
      pretty lig.first.get_default_settings
      true
    else
      Puppet.warning('No Logical Interconnect Groups with the given specifications were found.')
      false
    end
  end
end
