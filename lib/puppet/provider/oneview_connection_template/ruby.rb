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

Puppet::Type.type(:oneview_connection_template).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::ConnectionTemplate
    @data = {}
  end

  def exists?
    return true unless resource['data']
    @data = data_parse
    ct = @resourcetype.new(@client, @data)
    if ct.retrieve! && resource['ensure'] == :present
      resource_update(@data, @resourcetype)
    end
    ct.exists?
  end

  def create
    raise(Puppet::Error, 'This resource cannot be created.')
  end

  def destroy
    raise(Puppet::Error, 'This resource cannot be destroyed.')
  end

  def found
    Puppet.notice("\nConnection Template\n")
    ct = @resourcetype.find_by(@client, @data)
    unless ct.empty?
      puts "Found\n\s\sName: #{ct.first['name']}\n\s\sURI: #{ct.first['uri']}\n\n"
      return true
    end
    raise(Puppet::Error, 'This resource cannot be found.')
  end

  def get_schema
    ct = @resourcetype.new(@client, @data)
    true if pretty ct.schema
  end

  def get_connection_templates
    Puppet.notice("\nAll Connection Templates\n")
    ct = @resourcetype.find_by(@client, @data)
    if ct.empty?
      Puppet.warning('There are no connection templates in the Oneview appliance.')
      return false
    end
    ct.each do |item|
      puts "\s\sName: #{item['name']}\n\s\sURI: #{item['uri']}\n\n"
    end
    true
  end

  def get_default_connection_template
    Puppet.notice("\n\nDefault Connection Template")
    default = OneviewSDK::ConnectionTemplate.get_default(@client)
    if default['uri']
      puts "\nName: '#{default['name']}'"
      puts "(- maximumBandwidth: #{default['bandwidth']['maximumBandwidth']})"
      puts "(- typicalBandwidth: #{default['bandwidth']['typicalBandwidth']})\n\n"
      true
    end
  end
end
