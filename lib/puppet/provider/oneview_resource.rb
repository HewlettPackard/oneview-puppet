################################################################################
# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
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

module Puppet
  # Base provider for OneView resources
  class OneviewResource < Puppet::Provider
    desc 'Base provider for OneView resources'

    def initialize(value = {})
      super(value)
      @property_flush ||= {}
      @data ||= {}
      @client ||= client
      @resource_type ||= ov_resource_type
    end

    def self.client
      OneviewSDK::Client.new(login)
    end

    def client
      self.class.client
    end

    def self.instances
      resources = []
      ov_resource_type.get_all(client).each { |n| resources.push(n) }
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

    def exists?(states = [nil, :found])
      prepare_environment
      @item = @resource_type.new(@client, @data)
      return true if empty_data_check(states)
      return false unless @item.retrieve! && @item.like?(@data) && !@data['new_name']
      Puppet.debug "#{@resource_type} #{@item['name']} is up to date."
      true
      # @property_hash[:ensure] == :present # TODO: Future Improvement: Look into using property_hash for verifying existance globally
    end

    def create(action = :create)
      return true if resource_update
      Puppet.info "Performing #{action} of #{resource_name} #{@item['name']} using the following data: \n#{JSON.pretty_generate(@data)}."
      ov_resource = if action == :create
                      @resource_type.new(@client, @data).create
                    elsif action == :add
                      @resource_type.new(@client, @data).add
                    elsif action == :update
                      raise 'This resource relies on others to be created.'
                    end
      Puppet.debug "#{@resource_type} #{@item['name']} created successfully."
      @property_hash[:data] = ov_resource.data
      @property_hash[:ensure] = :present
    end

    def destroy(action = :delete)
      Puppet.debug "Performing removal of #{resource_name} matching the following data: #{JSON.pretty_generate(@data)}."
      if action == :delete
        get_single_resource_instance.delete
      elsif action == :remove
        get_single_resource_instance.remove
      elsif action == :multiple_delete
        @resource_type.find_by(@client, @data).map(&:delete)
      elsif action == :multiple_remove
        @resource_type.find_by(@client, @data).map(&:remove)
      end
      @property_hash[:ensure] = :absent
    end

    # This method should be overwritten by resources which require the @data to be modified.
    def data_parse; end

    def found
      find_resources
    end

    # Helpers
    def self.resource_name
      class_name = to_s
      class_name =~ /Oneview/
      shift_prefix = Regexp.last_match.nil? ? 2 : 1
      class_name.split('::')[2].split('_').drop(shift_prefix).collect(&:capitalize).join
    end

    def resource_name
      self.class.resource_name
    end

    def self.resource_variant
      to_s.split('::')[3].gsub(/Provider/, '')
    end

    def self.api_version
      @client ||= client
      api_ver = login[:api_version]
      if api_ver && api_ver < OneviewSDK::DEFAULT_API_VERSION
	 raise "The minimum API version supported is #{OneviewSDK::DEFAULT_API_VERSION}"
      end
      api_ver || @client.max_api_version
    end

    def api_version
      self.class.api_version
    end

    def resource_variant
      self.class.resource_variant
    end

    def self.ov_resource_type
      OneviewSDK.resource_named(resource_name, api_version, resource_variant)
    end

    def ov_resource_type
      self.class.ov_resource_type
    end
  end
end
