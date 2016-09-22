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

Puppet::Type.type(:oneview_logical_switch).provide(:oneview_logical_switch) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::LogicalSwitch
    @data = {}
    @switches = []
  end

  def exists?
    @data = data_parse
    @switches = @data.delete('switches') if @data['switches']
    empty_data_check
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    return true if resource_update(@data, @resourcetype)
    ls = @resourcetype.new(@client, @data)
    set_switches(ls, @switches)
    ls.create
  end

  def destroy
    get_single_resource_instance.delete
  end

  def found
    find_resources
  end

  def refresh
    get_single_resource_instance.refresh
  end

  def update_credentials
    ls = get_single_resource_instance
    @switches.each do |switch|
      update_hash = {}
      update_hash['logicalSwitchCredentials'] =
        [{ 'connectionProperties' =>
          [
            { 'valueFormat' => 'Unknown', 'propertyName' => 'SshBasicAuthCredentialUser', 'valueType' => 'String',
              'value' => switch['ssh_username'] },
            { 'valueFormat' => 'SecuritySensitive', 'propertyName' => 'SshBasicAuthCredentialPassword',
              'valueType' => 'String', 'value' => switch['ssh_password'] }
          ] }]
      update_hash['logicalSwitch'] = { 'switchCredentialConfiguration' => [{ 'sshUsername' => switch['ssh_username'],
                                                                             'snmpPort' => switch['snmp_port'],
                                                                             'snmpV1Configuration' =>
                                                                               { 'communityString' => switch['community_string'] },
                                                                             'snmpVersion' => switch['version'],
                                                                             'snmpV3Configuration' => nil,
                                                                             'switchUri' => switch['switchUri'],
                                                                             'logicalSwitchManagementHost' => switch['ip'] }],
                                       'type' => 'logical-switch',
                                       'uri' => ls['uri'],
                                       'name' => ls['name'],
                                       'description' => ls['description'] }
      put_request = @client.rest_put(ls['uri'], { 'body' => update_hash }, 200)
      @client.response_handler(put_request)
    end
  end

  # Helper Methods to treat switches and set credentials

  def set_switches(ls, resource)
    resource.each do |switch|
      switch['version'] = switch['version'] || nil
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
end
