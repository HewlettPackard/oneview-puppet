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

Puppet::Type::Oneview_enclosure.provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Enclosures using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  @resourcetype ||= OneviewSDK::Enclosure

  def initialize(*args)
    @resource_name = 'Enclosure'
    super(*args)
    @authentication = {}
    @patch_tags = {}
  end

  # Provider methods
  def exists?
    @data = data_parse
    empty_data_check
    %w(from op path value).each { |key| @patch_tags[key] = @data.delete(key) if @data[key] }
    %w(hostname username password).each { |key| @authentication[key] = @data.delete(key) if @data[key] }
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    patch_enclosure unless @patch_tags.empty?
    return true if resource_update(@data, @resourcetype)
    @data = @data.merge(@authentication)
    @resourcetype.new(@client, @data).add
    @property_hash[:ensure] = :present
    @property_hash[:data] = @data
    true
  end

  def destroy
    get_single_resource_instance.remove
    @property_hash.clear
    true
  end

  def found
    find_resources
  end

  def set_configuration
    enclosure = get_single_resource_instance
    enclosure.configuration
    true
  end

  def get_environmental_configuration
    enclosure = get_single_resource_instance
    pretty enclosure.environmental_configuration
    true
  end

  def set_environmental_configuration
    raise "\n\n Set environmental configuration is not currently supported via the Puppet/Ruby SDK \n"
  end

  def set_refresh_state
    raise 'A "refreshState" tag is required within data for the current operation.' unless @data['refreshState']
    refresh_state = @data.delete('refreshState')
    refresh_force_options = @data.delete('refreshForceOptions') || {}
    enclosure = get_single_resource_instance
    enclosure.set_refresh_state(refresh_state, refresh_force_options)
    true
  end

  def get_script
    enclosure = get_single_resource_instance
    enclosure.script
    true
  end

  def get_single_sign_on
    raise "\n\n Single Sign-On is not currently supported via Puppet \n"
  end

  def get_utilization
    utilization_parameters = @data.delete('utilization_parameters') || {}
    enclosure = get_single_resource_instance
    pretty enclosure.utilization(utilization_parameters)
    true
  end

  def patch_enclosure
    raise 'The "from" tag is not supported by the current version of the ruby sdk' if @patch_tags['from']
    raise 'The "op", "path" and "value" tags are required together when used for this operation.' unless
      @patch_tags['op'] && @patch_tags['path'] && @patch_tags['value']
    enclosure = get_single_resource_instance
    enclosure.patch(@patch_tags['op'], @patch_tags['path'], @patch_tags['value'])
  end
end
