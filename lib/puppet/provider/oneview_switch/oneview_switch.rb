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

Puppet::Type.type(:oneview_switch).provide(:oneview_switch) do
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
          data: data)
    end
  end

  # Provider methods
  def exists?
    @data = data_parse
    empty_data_check([:found, :get_type])
    return true if %w(found get_type).include?(resource['ensure'].to_s)
    !@resourcetype.find_by(@client, unique_id).empty?
  end

  def create
    raise 'This ensurable is not supported for this resource'
  end

  def destroy
    @resourcetype.find_by(@client, unique_id).first.remove
  end

  def found
    find_resources
  end

  def get_type
    if @data['name']
      Puppet.notice "\n\n Search for switch type #{@data['name']} started, displaying results bellow:\n"
      results = @resourcetype.get_type(@client, @data['name'])
      raise "\n\n No switch types corresponding to the name #{@data['name']} were found.\n" unless results
      pretty results
    else
      Puppet.notice "\n\n Search for switch types started, displaying results bellow:\n"
      pretty @resourcetype.get_types(@client)
    end
    true
  end

  # Remove port_name and subport_number from data hash for comparisons and usage
  def get_statistics
    port_name = @data.delete('port_name')
    subport_number = @data.delete('subport_number')
    switch = get_single_resource_instance
    pretty switch.statistics(port_name, subport_number)
    true
  end

  def get_environmental_configuration
    switch = get_single_resource_instance
    pretty switch.environmental_configuration
    true
  end
end
