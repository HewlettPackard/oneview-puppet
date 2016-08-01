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

require 'oneview-sdk'
require File.expand_path(File.join(File.dirname(__FILE__), 'common'))

Puppet::Type.newtype(:oneview_rack) do
  desc "Oneview's Rack Bundle"

  ensurable do
    defaultvalues
    # :nocov:
    # Get Methods
    newvalue(:found) do
      provider.found
    end

    newvalue(:get_device_topology) do
      provider.get_device_topology
    end

    newvalue(:add_rack_resource) do
      provider.add_rack_resource
    end

    newvalue(:remove_rack_resource) do
      provider.remove_rack_resource
    end
    # :nocov:
  end

  newparam(:name, namevar: true) do
    desc 'Rack name'
  end

  newparam(:data) do
    desc 'Rack data hash'
    def parse_rack_mount_uris(value)
      return unless value['rackMounts']
      raise 'rackMounts must be declared as an array' unless value['rackMounts'].is_a? Array
      value['rackMounts'].each do |mount|
        uri = mount['mountUri'] || mount['uri']
        raise 'The "mountUri" or "uri" parameter is required for each resource within rackMounts' unless uri
        next if uri.to_s[0..6].include?('/rest/')
        rack_mount_uri_parse(mount, uri)
      end
    end

    def rack_mount_uri_parse(mount, uri)
      uri = find_uri(uri)
      mount['mountUri'] = uri if mount['mountUri']
      mount['uri'] = uri if mount['uri']
    end

    def find_uri(uri)
      uri = uri.strip.split(',').map(&:strip)
      name = uri[0]
      type = uri[1]
      type = Object.const_get("OneviewSDK::#{type[0].capitalize}#{type[1..type.size]}")
      uri = type.find_by(@client, name: name).first
      raise 'The name and resoure type informed did not result in a match in the appliance' unless uri
      uri['uri']
    end

    validate do |value|
      raise Puppet::Error, 'Inserted value for data is not valid' unless value.class == Hash
      @client = OneviewSDK::Client.new(login)
      parse_rack_mount_uris(value)
    end
  end
end
