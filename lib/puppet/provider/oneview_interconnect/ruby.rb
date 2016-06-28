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
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'interconnect'))
require 'oneview-sdk'
require 'json'

Puppet::Type.type(:oneview_interconnect).provide(:ruby) do

    mk_resource_methods

    def initialize(*args)
        super(*args)
        @client = OneviewSDK::Client.new(login)
    end

    def exists?
        data = data_parse(resource['data'])
        interconnect = OneviewSDK::Interconnect.new(@client, name: data['name'])
        return interconnect.retrieve!
    end

    def found
        data = data_parse(resource['data'])
        interconnect = (OneviewSDK::Interconnect.find_by(@client, name: data['name'])).first
        if interconnect
            Puppet.notice("Interconnect #{interconnect['name']} URI=#{interconnect['uri']}")
            return true
        else
            Puppet.warning("No Interconnects with the given specifications were found.")
            return false
        end
    end

    # GET endpoints
    def get_interconnect_type
        Puppet.notice("\n\nInterconnects\n")
        interconnect = OneviewSDK::Interconnect.find_by(@client, {}).each do |ic|
            Puppet.notice("Interconnect #{ic['name']} URI=#{ic['uri']}\n")
            return true
        end
        if interconnect.size == 0
          Puppet.warning("No Interconnects were found.")
          return false
        end
    end

    def get_schema
        Puppet.notice("\n\nInterconnect Schema\n")
        data = data_parse(resource['data'])
        interconnect = OneviewSDK::Interconnect.new(@client, name: data['name'])
        if interconnect.retrieve!
          pretty interconnect.schema
          return true
        else
          Puppet.warning("No Interconnects with the given specifications were found.")
          return false
        end
    end

    # it is possible to query by either portName, subportNumber or nothing,
    # in case the user wants general statistics
    def get_statistics
      Puppet.notice("\n\nInterconnect Statistics\n")
      data = data_parse(resource['data'])
      interconnect = OneviewSDK::Interconnect.new(@client, name: data['name'])
      interconnect.retrieve!
      portName, subportNumber = []
      if data['subportStatistics']
        if data['subportStatistics']['portName']
          portName = data['subportStatistics']['portName']
        else
          portName = nil
        end
        if data['subportStatistics']['subportNumber']
          subportNumber = data['subportStatistics']['subportNumber']
        else
          subportNumber = nil
        end
      end
      query = interconnect.statistics(portName, subportNumber)
      pretty JSON.parse(query)
      return true
    end

    def get_name_servers
        OneviewSDK::Interconnect.find_by(@client, {}).each do |interconnect|

            # Retrieve name servers
            puts " - Name servers: #{interconnect.nameServers}"
        end
    end

    # PUT endpoints

end
