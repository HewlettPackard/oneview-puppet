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
require 'json'

Puppet::Type.type(:oneview_interconnect).provide(:ruby) do

  mk_resource_methods

  def initialize(*args)
      super(*args)
      @client = OneviewSDK::Client.new(login)
      @resourcetype = OneviewSDK::Interconnect
  end

  def exists?
    @data = data_parse
    @ports = @data.delete('ports') if @data['ports']
    @statistics = @data.delete('statistics') if @data['statistics']
    interconnect = if resource['ensure'] == :present
                     patch_check
                     resource_update(@data, @resourcetype)
                     @resourcetype.find_by(@client, @data)
                   else
                     @resourcetype.find_by(@client, @data)
                   end
    !interconnect.empty?
  end

  def create
    raise('This resource depends on other resources to be created.')
  end

  def destroy
    raise('This resource depends on other resources to be destroyed.')
  end

  def found
    find_resources
  end

  # GET endpoints ============================================================

  def get_types
    Puppet.notice("\n\nInterconnect Types\n")
    if @data == {}
      pretty @resourcetype.get_types(@client)
    else
      raise('You need to specify the Interconnect name') unless @data['name']
      pretty @resourcetype.get_type(@client, name: @data['name'])
    end
  end

  # it is possible to query by either portName, subportNumber or nothing (for all)
  def get_statistics
    Puppet.notice("\n\nInterconnect Statistics\n")
    interconnect = @resourcetype.find_by(@client, unique_id)
    raise('No Interconnects with the given specifications were found.') unless interconnect.first
    if @statistics
      @statistics['portName'] = nil unless @statistics['portName']
      @statistics['subportNumber'] = nil unless @statistics['subportNumber']
      puts interconnect.first.statistics(@statistics['portName'], @statistics['subportNumber'])
    else
      puts interconnect.first.statistics
    end
    true
  end

  def get_name_servers
    Puppet.notice("\n\nInterconnect Name Servers\n")
    interconnect = @resourcetype.find_by(@client, unique_id)
    raise('No Interconnects with the given specifications were found.') unless interconnect.first
    puts interconnect.first.name_servers
  end

  # PUT endpoints ============================================================

  # For each item in the hash ports, one port to be updated (key = port name)
  def update_ports
    interconnect = @resourcetype.find_by(@client, unique_id)
    raise('No Interconnects with the given specifications were found.') unless interconnect.first
    @ports.each do |port|
      interconnect.first.update_port(port['name'], port['attributes'])
      Puppet.notice("The port #{port['name']} has been updated.")
    end
  end

  def reset_port_protection
    Puppet.notice("\n\n Reset Port Protection \n")
    interconnect = @resourcetype.find_by(@client, unique_id)
    raise('No Interconnects with the given specifications were found.') unless interconnect.first
    raise('Could not complete the Port Protection Reset') unless interconnect.first.reset_port_protection
  end

  # Checks whether there is a patch operation
  def patch_check
    if @data['patch']
      @patch = @data.delete('patch')
      ic = @resourcetype.find_by(@client, unique_id).first
      ic.update_attribute(@patch['op'], @patch['path'], @patch['value'])
    end
  end
end
