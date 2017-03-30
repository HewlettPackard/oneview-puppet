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

Puppet::Type.type(:oneview_logical_switch).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Logical Switches using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def initialize(*args)
    super
    @switches = []
  end

  def exists?
    @data = data_parse
    @switches = @data.delete('switches') if @data['switches']
    super([nil, :found, :get_internal_link_sets])
  end

  def create
    return true if resource_update
    ls = @resource_type.new(@client, @data)
    set_switches(ls, @switches)
    ls.create
    @property_hash[:data] = ls.data
    @property_hash[:ensure] = :present
  end

  def refresh
    get_single_resource_instance.refresh
  end

  def get_internal_link_sets
    if @data['name']
      pretty ov_resource_type.get_internal_link_set(@client, @data['name'])
    else
      pretty ov_resource_type.get_internal_link_sets(@client)
    end
    true
  end

  def update_credentials
    raise 'This method was deprecated. If support for this feature is added on the SDK in the future, it will be reimplemented.'
  end

  # Helper Methods to treat switches and set credentials

  def set_switches(ls, switches)
    switches.each do |switch|
      switch['version'] = switch['version'] || nil
      set_credentials(ls,
                      switch['ip'],
                      new_ssh(switch['ssh_username'], switch['ssh_password']),
                      new_snmp(switch['snmp_port'], switch['community_string'], switch['version']))
    end
    switches
  end

  def new_ssh(username, password)
    ov_resource_type::CredentialsSSH.new(username, password)
  end

  def new_snmp(port, community_string, version = nil)
    ov_resource_type::CredentialsSNMPV1.new(port, community_string, version)
  end

  def set_credentials(ls, ip, ssh, snmp)
    ls.set_switch_credentials(ip, ssh, snmp)
  end
end
