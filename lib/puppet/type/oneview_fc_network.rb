################################################################################
# (C) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
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

Puppet::Type.newtype(:oneview_fc_network) do
  desc "Oneview's FC network"

  # :nocov:
  # Get methods
  ensurable do
    defaultvalues

    newvalue(:found) do
      provider.found
    end
    # :nocov:
  end

  newparam(:name, namevar: true) do
    desc 'FC network name'
  end

  newproperty(:data) do
    desc 'FC network data hash containing all specifications for the network'
    validate do |value|
      puts 'validation'
      puts value
      puts value.class
      # raise 'Inserted value for data is not valid' unless value.class == Hash
    end

    def property_matches?(current, desired)
      OneviewSDK::FCNetwork.new(client, current).like?(OneviewSDK::FCNetwork.new(client, desired))
      puts "property matches current: #{current}"
      puts "property matches desired: #{desired}"
      true
      # return true if super(current, desired)
      # return date_matches?(resource.parameter(:checksum).value, current, desired)
    end
    # def insync?(is)
    #   puts "\n\ninsync!\n\n"
    #   puts "\n\n is value: #{is}"
    #   puts "\n\n should value: #{should}"
    #   is.sort == should.sort
    # end
  end
end

def client
  OneviewSDK::Client.new(login)
end
