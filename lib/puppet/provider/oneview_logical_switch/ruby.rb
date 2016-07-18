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
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'logical_switch'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_logical_switch).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::LogicalSwitch
    @data
  end

  def exists?
    return true unless resource['data']
    @data = data_parse
    ls = @resourcetype.new(@client, name: @data['name'])
    if ls.retrieve! && resource['ensure'] == :present
      resource_update(@data, @resourcetype)
    end
    ls.exists?
  end

  def create
    ssh  = new_ssh(resource['ssh_username'], resource['ssh_password'])
  	snmp = new_snmp(resource['snmp_port'], resource['community_string'])

    ls = @resourcetype.new(@client, @data)
    set_credentials(ls, resource['switch1_ip'], ssh, snmp)
    set_credentials(ls, resource['switch2_ip'], ssh, snmp)
    true if ls.create
  end

  def destroy
    ls = get_ls
    puts ls.methods
    ls.delete if ls.retrieve!
  end

  def found
    ls = @resourcetype.find_by(@client, @data)
    Puppet.notice("\n\n\s\sFound Logical Switch"\
    " #{ls.first.data['name']} (URI: #{ls.first.data['uri']}) in Oneview Appliance\n")
    true if ls.first
  end

  def get_logical_switches
    Puppet.notice("\n\nLogical Switches\n")
    ls = @resourcetype.get_all(@client)
    if ls.empty?
      Puppet.warning('No Logical Switches were found in the Appliance.')
      return false
    end
    ls.each do |item|
      puts "\s\sName: #{item['name']}\n\s\sURI: #{item['uri']}\n\n"
    end
    true
  end

  def get_schema
    ls = get_ls
    true if pretty ls.schema
  end

  def refresh
    ls = get_ls
    true if pretty ls.refresh
  end
end
