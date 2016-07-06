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
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'server_profile_template'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_server_profile_template).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
  end

  def exists?
    return true if !resource['data']
    data = data_parse.clone
    spt = OneviewSDK::ServerProfileTemplate.new(@client, name: data['name'])
    # checking for updates once the state is not absent
    if spt.retrieve! && resource['ensure'] != 'absent'
      resource_update(spt_parse(data_parse), OneviewSDK::ServerProfileTemplate)
    end
    spt.retrieve!
  end

  def create
    data = spt_parse(data_parse)
    spt = OneviewSDK::ServerProfileTemplate.new(@client, data)
    spt.create!
  end

  def destroy
    data = data_parse
    spt = OneviewSDK::ServerProfileTemplate.new(@client, name: data['name'])
    spt.retrieve!
    spt.delete
  end

  def found
    data = data_parse(resource['data'])
    spt = OneviewSDK::ServerProfileTemplate.new(@client, name: data['name'])
    if spt.retrieve!
      Puppet.notice("\n\nFound Server Profile Template"\
      " #{spt['name']} (URI: #{spt['uri']}) in Oneview Appliance\n")
      true
    else
      Puppet.notice("\n\nNo Server Profile Templates with the specified data were"\
      " found the Oneview Appliance\n")
      false
    end
  end

  def get_server_profile_templates
    Puppet.notice("\n\nServer Profile Templates\n")
    data = spt_parse(data_parse) if resource['data']
    data = {} if !resource['data']
    spt = OneviewSDK::ServerProfileTemplate.find_by(@client, data)
    spt.each do |item|
      Puppet.notice("\n\nName: #{item['name']}\n URI: #{item['uri']}\n\n")
    end
    if spt.empty?
      Puppet.notice("\n\nNo Server Profile Templates with the specified data were"+
      " found on the Oneview Appliance\n")
      return false
    end
    true
  end

  def get_new_profile
    Puppet.notice("\n\nServer Profile Templates New Profile\n")
    data = spt_parse(data_parse)
    spt = OneviewSDK::ServerProfileTemplate.new(@client, data)
    unless spt.retrieve!
      Puppet.notice("\n\nNo Server Profile Templates with the specified data were"+
      " found on the Oneview Appliance\n")
      return false
    end
    spt.retrieve!
    puts spt.new_profile
    true
  end
end
