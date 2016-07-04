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
require 'json'

Puppet::Type.type(:oneview_interconnect).provide(:ruby) do

    mk_resource_methods

    def initialize(*args)
        super(*args)
        @client = OneviewSDK::Client.new(login)
    end

    # PATCH operations
    # Checks whether the patch should apply to 1) all or 2) a specific interconnect
    def exists?
      # In case there is no data hash (get types), it returns false right away
      if !resource['data']
        return false
      end

      data = data_parse(resource['data']) if data_parse(resource['data'])
      # 1)
      if !data['name'] && data['op'] && data['path'] && data['value']
        OneviewSDK::Interconnect.find_by(@client, {}).each do |ic|
          ic.retrieve!
          ic.update_attribute(data['op'], data['path'], data['value'])
        end
        Puppet.warning("All Interconnects have been updated")
        return true
      # 2)
      elsif data['name'] && data['op'] && data['path'] && data['value']
        interconnect = OneviewSDK::Interconnect.new(@client, name: data['name'])
        # Does this one exist? If not, skip the update.
        return false if !interconnect.retrieve!
        interconnect.retrieve!
        interconnect.update_attribute(data['op'], data['path'], data['value'])
        Puppet.warning("The Interconnect has been updated")
        return true
      # Common cases
      else
        interconnect = OneviewSDK::Interconnect.new(@client, name: data['name'])
        interconnect.retrieve!
        return interconnect.retrieve!
      end
    end

    def create
      Puppet.warning("This resource depends on other resources to be created.")
      return false
    end

    def destroy
      Puppet.warning("This resource depends on other resources to be destroyed.")
      return false
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

    # GET endpoints ============================================================

    def get_types
      Puppet.notice("\n\nInterconnect Types\n")
      pretty OneviewSDK::Interconnect.get_types(@client)
      return true
    end

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
      data = data_parse(resource['data'])
      OneviewSDK::Interconnect.find_by(@client, name: data['name']).each do |ic|
        Puppet.notice("\n\n - Name servers: #{ic.name_servers}\n")
      end
      return true
    end

    # PUT endpoints ============================================================

    # For each item in the hash ports, one port to be updated (key = port name)
    def update_ports
      data = data_parse(resource['data'])
      Puppet.notice("\n\n Update Ports \n")
      if data['ports']
        ports = data['ports']
        interconnect = OneviewSDK::Interconnect.new(@client, name: data['name'])
        interconnect.retrieve!
        ports.each do |key, value|
          interconnect.update_port(key, ports[key])
          Puppet.notice("\n\n The port #{key} has been updated. \n")
        end
        return true
      else
        Puppet.warning("No Port settings have been set in the manifest.")
        return false
      end
    end

    def reset_port_protection
      Puppet.notice("\n\n Reset Port Protection \n")
      data = data_parse(resource['data'])
      interconnect = OneviewSDK::Interconnect.new(@client, name: data['name'])
      if interconnect.retrieve!
        interconnect.reset_port_protection
        Puppet.notice("The Port Protection has been reset.")
        return true
      else
        Puppet.warning("No Interconnects with the given specifications were found.")
        return false
      end
    end



end
