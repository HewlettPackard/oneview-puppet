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
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'logical_interconnect'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_logical_interconnect).provide(:ruby) do

  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::LogicalInterconnect
    @data = {}
  end

  def exists?
    @data = data_parse
    li = if resource['ensure'] == :present
           resource_update(@data, @resourcetype)
           @resourcetype.find_by(@client, unique_id)
         else
           @resourcetype.find_by(@client, @data)
         end
    !li.empty?
  end

  def found
    find_resources
  end

  # GET ENDPOINTS =======================================

  def get_ethernet_settings
    get_endpoints(resource['data'], 'ethernetSettings')
  end

  def get_telemetry_configuration
    get_endpoints(resource['data'], 'telemetryConfiguration')
  end

  def get_qos_aggregated_configuration
    get_endpoints(resource['data'], 'qosConfiguration')
  end

  def get_snmp_configuration
    get_endpoints(resource['data'], 'snmpConfiguration')
  end

  def get_port_monitor
    get_endpoints(resource['data'], 'portMonitor')
  end

  def get_firmware
    get_endpoints(resource['data'], 'firmware')
  end

  def get_internal_vlans
    get_endpoints(resource['data'], 'vlanNetworks')
  end

  def get_forwarding_information_base
    get_endpoints(resource['data'], 'forwardingInformation')
  end

  # PUT/SET ENDPOINTS =======================================

  def set_ethernet_settings
    set_endpoints(resource['data'], 'ethernetSettings')
  end

  def set_telemetry_configuration
    set_endpoints(resource['data'], 'telemetryConfiguration')
  end

  def set_qos_aggregated_configuration
    set_endpoints(resource['data'], 'qosConfiguration')
  end

  def set_snmp_configuration
    set_endpoints(resource['data'], 'snmpConfiguration')
  end

  def set_port_monitor
    set_endpoints(resource['data'], 'portMonitor')
  end

  def set_firmware
    set_endpoints(resource['data'], 'firmware')
  end

  def set_compliance
    set_endpoints(resource['data'], 'compliance')
  end

  def set_internal_networks
    set_endpoints(resource['data'], 'internalNetworks')
  end

  def set_forwarding_information_base
    set_endpoints(resource['data'], 'forwardingInformation')
  end

end
