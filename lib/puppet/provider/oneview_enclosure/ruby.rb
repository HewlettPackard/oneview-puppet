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
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'enclosure'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_enclosure).provide(:ruby) do

  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::Enclosure.get_all(@client)
    matches.collect do |line|
      # Puppet.notice("Enclosure: #{line['name']}, URI: #{line['uri']}")
      name = line['name']
      data = line.inspect
      new(:name   => name,
          :ensure => :present,
          :data   => data
          )
    end
  end

  def self.prefetch(resources)
    packages = instances
    resources.keys.each do |name|
      if provider = packages.find{ |pkg| pkg.name == name }
        resources[name].provider = provider
      end
    end
  end

  def pretty(arg)
    return puts arg if arg.instance_of?(String)
    puts JSON.pretty_generate(arg)
  end

  # Provider methods

  def exists?
    # Gets the desired operation to perform
    state = resource['ensure'].to_s

    # Verify ensure flag and sets environment flags for operations
    case state
      when 'present'
        # Resource itself sends the name of the running proccess
        enclosure = get_enclosure(resource['data']['name'])
        enclosure_exists = false
        enclosure_exists = true if enclosure.first
        # Checking for and performing potential updates.
        if enclosure_exists
          Puppet.notice("#{resource} '#{resource['data']['name']}' located"+
          " in Oneview Appliance")
          enclosure_update(resource['data'], enclosure, resource)
          return true
        end
      when 'absent'
        # Resource itself sends the name of the running proccess
        enclosure = get_enclosure(resource['data']['name'])
        enclosure_exists = false
        enclosure_exists = true if enclosure.first
        Puppet.notice("#{resource} '#{resource['data']['name']}' not located"+
        " in Oneview Appliance") if enclosure_exists == false
        return enclosure_exists
      else
        enclosure = find_enclosures(resource['data'])
        enclosure_exists = false
        enclosure_exists = true if enclosure
        return enclosure_exists
    end
    @property_hash[:ensure] == :present
  end

  def create
    data = data_parse(resource['data'])
    data.delete('new_name') if data['new_name']
    enclosure = OneviewSDK::Enclosure.new(@client, data)
    enclosure.add
    @property_hash[:ensure] = :present
    @property_hash[:data] = data
  end

  def destroy
    enclosure = get_enclosure(resource['data']['name'])
    enclosure.first.remove
    @property_hash.clear
  end

  def found
    # Searches enclosures with data matching the manifest data
    data = data_parse(resource['data'])
    data.delete('connectionTemplateUri') if data['connectionTemplateUri'] == nil
    matches = OneviewSDK::Enclosure.find_by(@client, data)
    # If matches are found, iterate through them and notify. Else just notify.
    unless matches.empty?
       matches.each do |enclosure|
         Puppet.notice ( "\n\n Found matching enclosure #{enclosure['name']} "+
         "(URI: #{enclosure['uri']}) on Oneview Appliance\n" )
      end
      true
    else
      Puppet.notice("\n\n No enclosures with the specified data were found on "+
      "the Oneview Appliance\n")
      false
    end
  end

  def configured
      data = data_parse(resource['data'])
      enclosure = OneviewSDK::Enclosure.new(@client, data)
      enclosure_exists = enclosure.retrieve! ? true : false
      enclosure.configuration if enclosure.retrieve!
      puts "\n\nEnclosure #{enclosure['name']} Updated\n\n" if enclosure_exists
      puts "\n\nEnclosure #{enclosure['name']} does not exist\n\n" unless enclosure_exists
  end

  def retrieved_environmental_configuration
    data = data_parse(resource['data'])
    enclosure = OneviewSDK::Enclosure.new(@client, data)
    # enclosure_exists = enclosure.retrieve! ? true : false
    if enclosure.retrieve!
      configuration = enclosure.environmental_configuration
      puts "\nEnclosure #{enclosure['name']} environmental configuration:\n"
      pretty configuration
    end
    puts "\nEnclosure #{enclosure['name']} does not exist\n" unless enclosure.retrieve!
  end

  def set_environmental_configuration
      #TODO This endpoint is not yet implemented on the ruby sdk, this should be revisited if/once it is
      Puppet.notice("\n\n Set environmental configuration is not currently supported via Puppet \n")
  end

  def set_refresh_state
      data = data_parse(resource['data'])
      # Get the refreshState if it exists
      refresh_state = data['refreshState'] if data['refreshState']
      data.delete('refreshState') if data['refreshState']
      Puppet.error("\nThe 'refreshState' must be specified for this operation.\n") unless refresh_state
      # Get the refreshForceOptions if it exists
      refresh_force_options = false
      refresh_force_options = data['refreshForceOptions'] if data['refreshForceOptions']
      data.delete('refreshForceOptions') if data['refreshForceOptions']
      # Verify that the enclosure exists
      enclosure = OneviewSDK::Enclosure.new(@client, data)
      enclosure_exists = enclosure.retrieve! ? true : false
      puts "\nEnclosure #{enclosure['name']} does not exist\n" unless enclosure_exists
      # Sets the refresh state for the enclosure
      puts "\nSetting refresh state for Enclosure #{enclosure['name']}\n" if enclosure_exists && refresh_state
      return enclosure.set_refresh_state(refresh_state) if
      enclosure.retrieve! && refresh_state && refresh_force_options == false
      return enclosure.set_refresh_state(refresh_state, refresh_force_options) if
      enclosure.retrieve! && refresh_state && refresh_force_options
      # return true
  end

  def script_retrieved
      data = data_parse(resource['data'])
      enclosure = OneviewSDK::Enclosure.new(@client, data)
      enclosure_exists = enclosure.retrieve! ? true : false
      puts "\nRetrieving script from enclosure #{enclosure['name']}... \n" if enclosure_exists
      puts "\nEnclosure #{enclosure['name']} does not exist.\n" unless enclosure_exists
      enclosure.script if enclosure.retrieve!
  end

  def retrieved_single_sign_on
    #TODO This endpoint is not yet implemented on the ruby sdk, this should be revisited if/once it is
    Puppet.notice("\n\n Single Sign-On is not currently supported via Puppet \n")
  end

  def retrieved_utilization
    data = data_parse(resource['data'])
    # Get the utilization_parameters if it exists
    utilization_parameters = data['utilization_parameters'] if data['utilization_parameters']
    data.delete('utilization_parameters') if data['utilization_parameters']
    Puppet.error("\nThe 'utilization_parameters' must be specified for this operation.\n") unless utilization_parameters
    # Verify that the enclosure exists
    enclosure = OneviewSDK::Enclosure.new(@client, data)
    enclosure_exists = enclosure.retrieve! ? true : false
    puts "\nEnclosure #{enclosure['name']} does not exist\n" unless enclosure_exists
    # Retrieve utilization data
    puts "\nRetrieving utilization data for enclosure '#{enclosure['name']}'\n" if enclosure_exists && utilization_parameters
    pretty enclosure.utilization(utilization_parameters) if enclosure_exists && utilization_parameters
    return true if enclosure_exists && utilization_parameters
  end

end
