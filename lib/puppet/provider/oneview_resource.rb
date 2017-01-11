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

require_relative 'login'
require_relative 'common'
require 'oneview-sdk'

module Puppet
  # Base provider for OneView resources
  class OneviewResource < Puppet::Provider
    desc 'Base provider for OneView resources'

    def initialize(value = {})
      super(value)
      @property_flush ||= {}
      @data ||= {}
      @client ||= OneviewSDK::Client.new(login)
      api_version = login[:api_version] || 200
      @resourcetype ||= if api_version == 200
                          Object.const_get("OneviewSDK::API#{api_version}::#{@resource_name}")
                        else
                          Object.const_get("OneviewSDK::API#{api_version}::C7000::#{@resource_name}")
                        end
    end

    def self.oneview_class
      @resourcetype
    end

    def oneview_class
      @resourcetype
    end

    def self.client
      OneviewSDK::Client.new(login)
    end

    def self.instances
      resources = []
      oneview_class.get_all(client).each { |n| resources.push(n) }
      resources.collect do |res|
        resource = {}
        resource[:data] = Hash[res.data.map { |k, v| [k.to_sym, v] }]
        resource[:ensure] = resource[:data][:state] == 'Active' ? :present : :absent
        resource[:name] = resource[:data][:name]
        new(resource)
      end
    end

    # TODO: Would be awesome to have this working for everything/most types. Future improvement.
    # def self.prefetch(resources)
    #   instances.each do |instance|
    #     puts "instance name: #{instance.name}"
    #     puts "resources instance.name: #{resources[instance.name]}"
    #     puts "resources count: #{resources.count}"
    #     resources[instance.name].provider = instance if resources[instance.name]
    #   end
    # end

    def data
      @property_hash[:data]
    end

    def exists?
      @property_hash[:ensure] == :present
    end

    # TODO: Would be awesome to have this working for everything/most types. Future improvement. Leaving as is in the meanwhile for filler.
    def create
      true
    end

    # TODO: Would be awesome to have this working for everything/most types. Future improvement. Leaving as is in the meanwhile for filler.
    def destroy
      true
    end
  end
end
