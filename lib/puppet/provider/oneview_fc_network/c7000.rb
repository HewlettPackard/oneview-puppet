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

Puppet::Type::Oneview_fc_network.provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Fiber Channel Networks using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  # mk_resource_methods

  def initialize(*args)
    super(*args)
  end

  # Provider methods
  def exists?
    @data = data_parse
    puts "\n\ngoing through exists"
    @property_hash[:ensure] == :present
  end

  def self.prefetch(resources)
    instances.each do |instance|
      resources[instance.name].provider = instance if resources[instance.name]
      # if resources[instance.name]
      #   puts resources[instance.name].inspect
      #   resources[instance.name].provider = instance
      # end
    end
  end

  def client
    OneviewSDK::Client.new(login)
  end

  def data
    puts "\n\ngoing through data"
    @property_hash[:data]
  end

  def data=(value)
    puts "\n\n going through data=(value)"
    existing_ov_resource = ov_resource_type.new(client, @property_hash[:data])
    new_ov_resource = ov_resource_type.new(client, value)
    puts existing_ov_resource.like?(new_ov_resource) ? @property_hash[:data] : value
    @property_flush[:data] = existing_ov_resource.like?(new_ov_resource) ? @property_hash[:data] : value
  end

  def flush
    puts "\n\ngoing through flush"
    array_arguments = []
    puts "\n\n property flush: #{@property_flush.sort}"
    if @property_flush
      array_arguments << :data << @property_flush[:data] if @property_flush[:data]
    end
    puts "\n\n array arguments: #{array_arguments}"
    array_arguments
    # fooset(array_arguments, resource[:name]) unless array_arguments.empty?
  end

  def create
    # return true if resource_update(@data, @resourcetype)
    ov_resource = @resourcetype.new(@client, @data).create
    @property_hash[:ensure] = :present
    @property_hash[:data] = ov_resource.data
    true
  end

  def destroy
    get_single_resource_instance.delete
    @property_hash.clear
    true
  end

  def resource_name
    'FCNetwork'
  end

  def self.resource_name
    'FCNetwork'
  end
end
