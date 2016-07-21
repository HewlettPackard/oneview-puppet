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

Puppet::Type.type(:oneview_logical_switch).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::LogicalSwitch
    @data = {}
    @switches = []
  end

  def exists?
    return true unless resource['data']
    @data = data_parse
    @switches = @data.delete('switches') if @data['switches']
    ls = @resourcetype.new(@client, name: @data['name'])
    if ls.retrieve! && resource['ensure'] == :present
      resource_update(@data, @resourcetype)
    end
    ls.exists?
  end

  def create
    ls = @resourcetype.new(@client, @data)
    set_switches(ls, @switches)
    true if ls.create
  end

  def destroy
    ls = get_ls
    ls.delete
  end

  def found
    ls = @resourcetype.find_by(@client, @data)
    raise(Puppet::Error, 'No Logical Switches were found in the Appliance.') unless ls.first
    Puppet.notice("\n\n\s\sFound Logical Switch"\
    " #{ls.first.data['name']} (URI: #{ls.first.data['uri']}) in Oneview Appliance\n")
    true
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
    pretty ls.schema
    true
  end

  def refresh
    ls = get_ls
    ls.refresh
    true
  end

  # Helper Methods to treat switches and set credentials

  def set_switches(ls, resource)
    resource.each do |switch|
      switch['version'] = nil unless switch['version']
      set_credentials(ls,
                      switch['ip'],
                      new_ssh(switch['ssh_username'], switch['ssh_password']),
                      new_snmp(switch['snmp_port'], switch['community_string'], switch['version']))
    end
  end

  def new_ssh(username, password)
    OneviewSDK::LogicalSwitch::CredentialsSSH.new(username, password)
  end

  def new_snmp(port, community_string, version = nil)
    OneviewSDK::LogicalSwitch::CredentialsSNMPV1.new(port, community_string, version)
  end

  def set_credentials(ls, ip, ssh, snmp)
    ls.set_switch_credentials(ip, ssh, snmp)
  end

  # Gets the logical switch object from Oneview
  def get_ls(message = nil)
    Puppet.notice("\n\n#{message}\n") if message
    ls = OneviewSDK::LogicalSwitch.new(@client, name: @data['name'])
    raise 'No Logical Switches were found in Oneview Appliance.' unless ls.retrieve!
    ls
  end
end
