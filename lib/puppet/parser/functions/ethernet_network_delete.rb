require 'oneview-sdk'

module Puppet::Parser::Functions
  newfunction(:ethernet_network_delete) do |args|

    attributes = args[0]

    attributes.each { |key,value| attributes[key] = nil if value == 'nil' } ## Removes quotes from nil values inside the hash
    attributes.each { |key,value| attributes[key] = false if value == 'false' } ## Removes quotes from false values inside the hash

    matches = OneviewSDK::EthernetNetwork.find_by(@client, name: attributes['name'])
    ethernet2 = matches.first
    ethernet2.delete
    puts "\nSucessfully deleted ethernet-network '#{attributes['name']}'."


  end
end
