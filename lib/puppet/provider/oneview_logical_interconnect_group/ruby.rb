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
# require File.expand_path(File.join(File.dirname(__FILE__), '..', 'logical_interconnect_group'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_logical_interconnect_group).provide(:ruby) do

  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
  end

  def exists?
    return true if !resource['data'] || resource['data'].size == 0
    data = data_parse(resource['data'])
    lig = OneviewSDK::LogicalInterconnectGroup.new(@client, name: data['name'])
    # lig.retrieve!
    # if lig.retrieve!
    #   puts lig.methods
    #   puts lig
    #   #update
    #   true
    # else
    #   false
    # end
  end

  def found
    data = data_parse(resource['data'])
    lig = OneviewSDK::LogicalInterconnectGroup.new(@client, name: data['name'])
    if lig.retrieve!
      Puppet.notice ( "\n\nFound logical interconnect group"+
      " #{lig['name']} on Oneview Appliance\n")
      return true
    else
      Puppet.notice("\n\nNo logical interconnect groups with the specified data were"+
      " found on the Oneview Appliance\n")
      return false
    end
  end

  def create
    data = data_parse(resource['data'])
    lig = OneviewSDK::LogicalInterconnectGroup.new(@client, name: data['name'])
    lig.create
    return lig.retrieve!
  end

  def destroy
    data = data_parse(resource['data'])
    lig = OneviewSDK::LogicalInterconnectGroup.new(@client, name: data['name'])
    lig.retrieve!
    return lig.delete
  end

  # GET ENDPOINTS =======================================

  def get_logical_interconnect_group
    Puppet.notice("\n\nLogical Interconnect Groups\n")
    options = {}
    options = data_parse(resource['data']) if resource['data']
    OneviewSDK::LogicalInterconnectGroup.find_by(@client, options).each do |lig|
      Puppet.notice ( "\n\nFound logical interconnect group"+
      " #{lig['name']} (URI #{lig['uri']}) in Oneview Appliance\n")
    end
    true
  end

  def get_settings
    Puppet.notice("\n\nLogical Interconnect Group Settings\n")
    data = data_parse(resource['data'])
    lig = OneviewSDK::LogicalInterconnectGroup.new(@client, data)
    if lig.retrieve!
      pretty lig.get_settings
      return true
    else
      Puppet.warning("No Logical Interconnect Groups with the given specifications were found.")
      return false
    end
  end

  def get_default_settings
    Puppet.notice("\n\nLogical Interconnect Group Default Settings\n")
    data = data_parse(resource['data'])
    lig = OneviewSDK::LogicalInterconnectGroup.new(@client, data)
    if lig.retrieve!
      pretty lig.get_default_settings
      return true
    else
      Puppet.warning("No Logical Interconnect Groups with the given specifications were found.")
      return false
    end
  end

  def get_schema
    Puppet.notice("\n\nLogical Interconnect Group Schema\n")
    data = data_parse(resource['data'])
    lig = OneviewSDK::LogicalInterconnectGroup.new(@client, data)
    if lig.retrieve!
      pretty lig.schema
      return true
    else
      Puppet.warning("No Logical Interconnect Groups with the given specifications were found.")
      return false
    end
  end

  # PUT/SET ENDPOINTS =======================================

  # def set_ethernet_settings
  #   set_endpoints(resource['data'], 'ethernetSettings')
  # end

end
