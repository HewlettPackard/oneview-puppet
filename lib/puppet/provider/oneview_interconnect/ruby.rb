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

Puppet::Type.type(:oneview_interconnect).provide(:ruby) do

    mk_resource_methods

    def initialize(*args)
        super(*args)
        @client = OneviewSDK::Client.new(login)
    end

    def exists?
        data = data_parse(resource['data'])
        interconnect = OneviewSDK::Interconnect.find_by(@client, data)
        return true if interconnect.first
    end

    def found
        data = data_parse(resource['data'])
        interconnect = (OneviewSDK::Interconnect.find_by(@client, data)).first
        if interconnect
            Puppet.notice("Interconnect #{interconnect['name']} URI=#{interconnect['uri']}")
            return true
        else
            Puppet.notice("No Interconnects with the given specifications were found.")
            return false
        end
    end

    # GET endpoints
    def get_interconnect_type
        Puppet.notice("\n\nInterconnects\n")
        interconnect = OneviewSDK::Interconnect.find_by(@client, {}).each do |ic|
            Puppet.notice("Interconnect #{ic['name']} URI=#{ic['uri']}\n")
        end
        Puppet.warning("No Interconnects were found.") if interconnect.size == 0
    end

    def get_schema
        Puppet.notice("\n\nInterconnect Schema\n")
        
        interconnect = OneviewSDK::Interconnect.new(@client, data)
        interconnect.retrieve!
        puts interconnect.schema
    end

    def get_statistics
    end

    def get_subport_statistics
    end

    def get_name_servers
        OneviewSDK::Interconnect.find_by(@client, {}).each do |interconnect|

            # Retrieve name servers
            puts " - Name servers: #{interconnect.nameServers}"
        end
    end

    # PUT endpoints

end