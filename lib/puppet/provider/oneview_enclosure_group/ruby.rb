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
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'enclosure_group'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_enclosure_group).provide(:ruby) do

  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
  end

  # def self.instances
  #   @client = OneviewSDK::Client.new(login)
  #   matches = OneviewSDK::EnclosureGroup.get_all(@client)
  #   matches.collect do |line|
  #     name = line['name']
  #     data = line.data
  #     new(  :name   => name,
  #           :ensure => :present,
  #           :data   => data
  #         )
  #   end
  # end

  def exists?
    state = resource['ensure']
    data = enclosure_group_parse(resource['data'])
    enclosure_group = OneviewSDK::EnclosureGroup.new(@client, name: data['name'])
    if enclosure_group.retrieve! && state == :present
      Puppet.notice("#{resource} '#{resource['data']['name']}' located"+
      " in Oneview Appliance")
      enclosure_group_update(data, enclosure_group, resource)
      true
    elsif enclosure_group.retrieve! && state == :absent
      true
    elsif state == :found
      true
    end
    # @property_hash[:ensure] == :present
  end

  def create
    data = enclosure_group_parse(resource['data'])
    data.delete('new_name') if data['new_name']
    enclosure_group = OneviewSDK::EnclosureGroup.new(@client, data)
    enclosure_group.create
    @property_hash[:ensure] = :present
    @property_hash[:data] = data
  end

  def destroy
    enclosure_group = get_enclosure_group(resource['data']['name'])
    enclosure_group.delete
    @property_hash.clear
  end

  def found
    # Searches enclosure groups with data matching the manifest data
    data = data_parse(resource['data'])
    matches = OneviewSDK::EnclosureGroup.find_by(@client, data)
    # If matches are found, iterate through them and notify. Else just notify.
    if matches
       matches.each { |enclosure| Puppet.notice ("\n\n Found matching enclosure "+
      "group #{enclosure['name']} (URI: #{enclosure['uri']}) on Oneview Appliance\n") }
      true
    else
      Puppet.notice("No enclosure groups with the specified data were found on the "+
      " Oneview Appliance")
      false
    end
  end

  def get_script
    data = data_parse(resource['data'])
    matches = OneviewSDK::EnclosureGroup.find_by(@client, data)
    unless matches.empty?
      matches.each { |enclosure| Puppet.notice ( "\n\nFound enclosure group"+
      " #{enclosure['name']} (URI: #{enclosure['uri']}) on Oneview Appliance\n")
      Puppet.notice ( "Its script contents are:\n#{enclosure.get_script}\n" )}
      true
    else
      Puppet.notice("\n\nNo enclosure groups with the specified data were"+
      " found on the Oneview Appliance\n")
      false
    end
  end

  def set_script
   data = data_parse(resource['data'])
   script = data['script'] if data['script']
   data.delete('script') if data['script']
   if script
     matches = OneviewSDK::EnclosureGroup.find_by(@client, data)
     unless matches.empty?
       matches.each { |enclosure| Puppet.notice ( "\n\nFound enclosure group"+
       " #{enclosure['name']} (URI: #{enclosure['uri']}) on Oneview Appliance\n")
       Puppet.notice ("Setting its script to:\n'#{script}'\n")
       enclosure.set_script(script)}
       puts 'set'
       true
     else
       Puppet.notice("\n\nNo enclosure groups with the specified data were"+
       " found on the Oneview Appliance\n")
       puts 'not found'
       false
     end
   else
     Puppet.notice ( "\n\nThe 'script' field is required in data hash to run"+
      " the set_script option")
      puts 'missing scrpt'
      false
   end
 end

end
