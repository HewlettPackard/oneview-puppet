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

Puppet::Type.type(:oneview_server_hardware).provide(:oneview_server_hardware) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::ServerHardware
    # Initializes the data so it is parsed only on exists and accessible throughout the methods
    # This is not set here due to the 'resources' variable not being accessible in initialize
    @data = {}
    @authentication = {}
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::ServerHardware.get_all(@client)
    matches.collect do |line|
      name = line['name']
      data = line.inspect
      new(name: name,
          ensure: :present,
          data: data)
    end
  end

  # Provider methods
  def exists?
    @data = data_parse
    empty_data_check
    data_parse_for_general
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    @data = @data.merge(@authentication)
    @data['hostname'] = @data.delete('name') if @data['name']
    @resourcetype.new(@client, @data).add
    @property_hash[:ensure] = :present
    @property_hash[:data] = @data
    true
  end

  def destroy
    get_single_resource_instance.remove
    @property_hash.clear
  end

  def found
    find_resources
  end

  def get_bios
    pretty get_single_resource_instance.get_bios
    true
  end

  def get_ilo_sso_url
    pretty get_single_resource_instance.get_ilo_sso_url
    true
  end

  def get_java_remote_sso_url
    pretty get_single_resource_instance.get_java_remote_sso_url
    true
  end

  def get_remote_console_url
    pretty get_single_resource_instance.get_remote_console_url
    true
  end

  def get_environmental_configuration
    pretty get_single_resource_instance.environmental_configuration
    true
  end

  def get_utilization
    query_parameters = @data.delete('queryParameters') if @data['queryParameters']
    pretty get_single_resource_instance.utilization(query_parameters || {})
    true
  end

  def update_ilo_firmware
    pretty get_single_resource_instance.update_ilo_firmware
    true
  end

  def set_power_state
    power_state = set_power_state_validation
    force = @data.delete('force') || false
    server_hardware = get_single_resource_instance
    if power_state.casecmp('on').zero?
      server_hardware.power_on(force)
    else
      server_hardware.power_off(force)
    end
  end

  def set_refresh_state
    raise 'A "state" specified in data is required for this action.' unless @data['state']
    state = @data.delete('state')
    options = @data.delete('options') || {}
    get_single_resource_instance.set_refresh_state(state, options)
  end

  def data_parse_for_general
    @data['name'] = @data.delete('hostname') if @data['hostname']
    @data.each do |key, _value|
      case key
      when 'username' then
        @authentication['username'] = @data.delete('username')
      when 'password' then
        @authentication['password'] = @data.delete('password')
      end
    end
  end

  def set_power_state_validation
    raise 'A "power_state" specified in data is required for this action.' unless @data['power_state']
    power_state = @data.delete('power_state')
    raise 'Invalid power_state specified in data. Valid values are "On" or "Off"' unless
      power_state.casecmp('off').zero? || power_state.casecmp('on').zero?
    power_state
  end
end
