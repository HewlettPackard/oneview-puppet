require 'oneview-sdk'

module Puppet::Parser::Functions
    newfunction(:ethernet_network_create) do |args|


    options = args[0] ## Creates the Hash "options" using the arguments received
    options.each { |key,value| options[key] = nil if value == 'nil' } ## Removes quotes from nil values inside the hash
    options.each { |key,value| options[key] = false if value == 'false' } ## Removes quotes from false values inside the hash

    # Creating a ethernet network
    ethernet = OneviewSDK::EthernetNetwork.new(@client, options)
    ethernet.create
    puts "\nCreated ethernet-network '#{ethernet[:name]}' sucessfully.\n  uri = '#{ethernet[:uri]}'"

    end
end
