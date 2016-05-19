require 'oneview-sdk'

module Puppet::Parser::Functions
  newfunction(:ethernet_network_delete) do |args|

    attributes = args[0]

    attributes.each { |key,value| attributes[key] = nil if value == 'nil' } ## Removes quotes from nil values inside the hash
    attributes.each { |key,value| attributes[key] = false if value == 'false' } ## Removes quotes from false values inside the hash

    network_exists = false
    matches = OneviewSDK::EthernetNetwork.find_by(@client, name: attributes['name'])
    network_exists = true if matches.first

      matches.first.delete if network_exists
      puts "\nDeleted ethernet-network '#{attributes['name']}' successfully.\n" if network_exists

      puts "\nThere is no ethernet network named #{attributes['name']}.\n" if !network_exists


  end
end
