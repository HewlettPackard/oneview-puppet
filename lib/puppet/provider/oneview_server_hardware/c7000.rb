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

Puppet::Type.type(:oneview_server_hardware).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Server Hardwares using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def initialize(*args)
    super
    @authentication = {}
    @patch_tags = {}
  end

  # Provider methods
  def exists?
    prepare_environment
    empty_data_check
    data_parse_for_general
    return false if @patch_tags.any?
    @resource_type.find_by(@client, @data).any?
  end

  def create
    return patch unless @patch_tags.empty?
    return true if resource_update
    @data = @data.merge(@authentication)
    @data['hostname'] = @data.delete('name') if @data['name']
    ov_resource = @resource_type.new(@client, @data).add
    @property_hash[:data] = ov_resource.data
    @property_hash[:ensure] = :present
  end

  def destroy
    super(:remove)
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
    %w(from op path value).each { |key| @patch_tags[key] = @data.delete(key) if @data[key] }
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

  def patch
    raise 'The "from" tag is not supported by the current version of the ruby sdk' if @patch_tags['from']
    raise 'The "op", "path" and "value" tags are required together when used for this operation.' unless
      @patch_tags['op'] && @patch_tags['path'] && @patch_tags['value']
    server_hardware = get_single_resource_instance
    pretty server_hardware.patch(@patch_tags['op'], @patch_tags['path'], @patch_tags['value'])
    true
  end
end
