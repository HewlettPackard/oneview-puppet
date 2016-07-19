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

# Methods used to treat and create credentials manually

def set_switches(ls, resource)
  resource['switches'].each do |switch|
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
