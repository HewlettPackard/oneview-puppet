require 'oneview-sdk'

module Puppet::Parser::Functions
  newfunction(:ethernet_network_create) do |args|

    options = args[0] # to keep the sdk function as close as possible to original

    options.each { |key,value| options[key] = nil if value == 'nil' } ## Removes quotes from nil values inside the hash
    options.each { |key,value| options[key] = false if value == 'false' } ## Removes quotes from false values inside the hash

    # puts options # debugging purposes

    # Creating a ethernet network

    network_exists = false
    matches = OneviewSDK::EthernetNetwork.find_by(@client, name: options['name'])
    network_exists = true if matches.first

    puts "\nAn ethernet network named #{options['name']} already exists.\n" if network_exists

    # if !network_exists
      ethernet = OneviewSDK::EthernetNetwork.new(@client, options) if !network_exists
      ethernet.create if !network_exists
      puts "\nCreated ethernet-network '#{ethernet[:name]}' sucessfully.\n  uri = '#{ethernet[:uri]}'" if !network_exists
    # end



  end
end
