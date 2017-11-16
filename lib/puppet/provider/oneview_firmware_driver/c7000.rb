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

Puppet::Type.type(:oneview_firmware_driver).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Firmware Drivers using the C7000 variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def initialize(*args)
    super(*args)
    @attributes = {}
  end

  # Provider methods
  def exists?
    prepare_environment
    data_parse_for_general
    @resource_type.find_by(@client, @data).any?
  end

  def create
    @data = @data.merge(@attributes)
    @data['customBaselineName'] = @data.delete('name') if @data['name']
    @resource_type.new(@client, @data).create
    @property_hash[:ensure] = :present
    @property_hash[:data] = @data
    true
  end

  def destroy
    super(:remove)
  end

  def data_parse_for_general
    @data['name'] = @data.delete('customBaselineName') if @data['customBaselineName']
    @data.each do |key, _value|
      case key
      when 'baselineUri' then
        @attributes['baselineUri'] = @data.delete('baselineUri')
      when 'hotfixUris' then
        @attributes['hotfixUris'] = @data.delete('hotfixUris')
        parse_uris_for_firmware_driver('hotfixUris', @attributes['hotfixUris'])
      end
    end
  end

  def parse_uris_for_firmware_driver(key, value, extra = nil)
    if value.is_a? Array
      value.each_with_index do |array_value, array_key|
        parse_uris_for_firmware_driver(key, array_value, array_key)
      end
      return true
    end
    return if value.to_s[0..6].include?('/rest/')
    firmware_driver = @resource_type.find_by(@client, name: value)
    raise "No #{key}s found on the appliance matching the provided name #{value}. Provide a valid name or uri." if firmware_driver.empty?
    @attributes[key][extra] = firmware_driver.first['uri'] if extra
  end
end
