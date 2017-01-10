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

require_relative '../login'
require_relative '../common'
require 'oneview-sdk'

Puppet::Type.type(:oneview_connection_template).provide(:c7000) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::ConnectionTemplate
    @data = {}
  end

  def exists?
    @data = data_parse
    ct = if resource['ensure'] == :present
           resource_update(@data, @resourcetype)
           @resourcetype.find_by(@client, unique_id)
         else
           @resourcetype.find_by(@client, @data)
         end
    !ct.empty?
  end

  def create
    raise('This resource relies on others to be created.')
  end

  def destroy
    raise('This resource relies on others to be destroyed.')
  end

  def found
    find_resources
  end

  def get_default_connection_template
    Puppet.notice("\n\nDefault Connection Template")
    default = @resourcetype.get_default(@client)
    if default['uri']
      puts "\nName: '#{default['name']}'"
      puts "(- maximumBandwidth: #{default['bandwidth']['maximumBandwidth']})"
      puts "(- typicalBandwidth: #{default['bandwidth']['typicalBandwidth']})\n\n"
    end
    true
  end
end
