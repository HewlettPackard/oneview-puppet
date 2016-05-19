require 'oneview-sdk'

module Puppet::Parser::Functions
  newfunction(:ethernet_network_create) do |args|

    options = args[0] # to keep the sdk function as close as possible to original

    options.each { |key,value| options[key] = nil if value == 'nil' } ## Removes quotes from nil values inside the hash
    options.each { |key,value| options[key] = false if value == 'false' } ## Removes quotes from false values inside the hash

    # puts options # debugging purposes

    # Creating a ethernet network

    matches = OneviewSDK::EthernetNetwork.find_by(@client, name: options['name'])
    ethernet2 = matches.first

    if ethernet2 # checking whether the given ethernet network exists
      puts "\nAn ethernet network named #{options['name']} already exists.\n"
    else
      ethernet = OneviewSDK::EthernetNetwork.new(@client, options)
      ethernet.create
      puts "\nCreated ethernet-network '#{ethernet[:name]}' sucessfully.\n  uri = '#{ethernet[:uri]}'"
    end



  end
end
