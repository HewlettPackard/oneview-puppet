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

Puppet::Type.type(:oneview_switch).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::Switch
    # Initializes the data so it is parsed only on exists and accessible throughout the methods
    # This is not set here due to the 'resources' variable not being accessible in initialize
    @data = {}
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::Switch.get_all(@client)
    matches.collect do |line|
      name = line['name']
      data = line.inspect
      new(name: name,
          ensure: :present,
          data: data
         )
    end
  end

  # TODO: eventually implement this prefetch method as it seems useful but requires an investigation into it
  # def self.prefetch(resources)
  #   packages = instances
  #   resources.keys.each do |name|
  #     if provider = packages.find { |pkg| pkg.name == name }
  #       resources[name].provider = provider
  #     end
  #   end
  # end

  # Provider methods

  def exists?
    state = resource['ensure'].to_s
    @data = data_parse
    # # TODO: This validation should be run on the "type" itself
    # # In case it is not, this part of the code should be enabled
    # # Verify if data is set for resources that need it, else fail
    # unless resource['data'] || (state == 'found')
    #   fail("A 'data' Hash is required for the present operation")
    # end
    return true if state == 'found' || state == 'get_type'
    switch = @resourcetype.find_by(@client, @data).first
    switch ? true : false
  end

  def create
    # This returns method unavailable
    @resourcetype.new(@client, @data).create
  end

  def destroy
    switch = @resourcetype.find_by(@client, @data)
    # FIXME: Due to a oneview bug, at the moment switches are returning results twice through find,
    # so the validation bellow will always fail. This should be re-enabled once the sdk is able to
    # handle that oneview issue
    # fail 'More than one resource located with the specified data.' if switch.size > 1
    switch.first.remove
  end

  def found
    # Searches Switchs with data matching the manifest data
    retrieved_resource = @resourcetype.find_by(@client, @data)
    # If resources are found, iterate through them and notify. Else just notify.
    fail 'No Switches with the specified data were found on the Oneview Appliance' if retrieved_resource.empty?
    retrieved_resource.each do |switch|
      Puppet.notice "\n\n Found matching Switch #{switch['name']} (URI: #{switch['uri']}) on Oneview Appliance\n"
    end
    true
  end

  def get_type
    if @data['name']
      Puppet.notice "\n\n Search for switch type #{@data['name']} started, displaying results bellow:\n"
      results = @resourcetype.get_type(@client, @data['name'])
      fail "\n\n No switch types corresponding to the name #{@data['name']} were found.\n" unless results
      pretty results
    else
      Puppet.notice "\n\n Search for switch types started, displaying results bellow:\n"
      pretty @resourcetype.get_types(@client)
    end
    true
  end

  def get_statistics
    # Remove port_name and subport_number from data hash for comparisons and usage
    port_name = separate_from_data('port_name')
    subport_number = separate_from_data('subport_number')
    #
    switch = @resourcetype.find_by(@client, @data)
    fail 'No Switches with the specified data were found on the Oneview Appliance' if switch.empty?
    # FIXME: Due to a oneview bug, at the moment switches are returning results twice through find,
    # so the validation bellow will always fail. This should be re-enabled once the sdk is able to
    # handle that oneview issue
    # fail 'More than one resource located with the specified data.' if switch.size > 1
    pretty switch.first.statistics(port_name, subport_number)
    true
  end

  def get_environmental_configuration
    switch = @resourcetype.find_by(@client, @data)
    fail 'No Switches with the specified data were found on the Oneview Appliance' if switch.empty?
    # FIXME: Due to a oneview bug, at the moment switches are returning results twice through find,
    # so the validation bellow will always fail. This should be re-enabled once the sdk is able to
    # handle that oneview issue
    # fail 'More than one resource located with the specified data.' if switch.size > 1
    pretty switch.first.environmental_configuration
    true
  end

  def separate_from_data(attribute)
    return nil unless @data[attribute]
    value = @data[attribute]
    @data.delete(attribute)
    value
  end
end
