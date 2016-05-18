require 'oneview-sdk'

module Puppet::Parser::Functions
  newfunction(:ethernet_network_sample) do |args|


options = args[0] ## Creates the Hash "options" using the arguments received
options.each { |key,value| options[key] = nil if value == 'nil' } ## Removes quotes from nil values inside the hash
options.each { |key,value| options[key] = false if value == 'false' } ## Removes quotes from false values inside the hash


    # Creating a ethernet network
    ethernet = OneviewSDK::EthernetNetwork.new(@client, options)
    ethernet.create
    puts "\nCreated ethernet-network '#{ethernet[:name]}' sucessfully.\n  uri = '#{ethernet[:uri]}'"

    # Find recently created network by name
    matches = OneviewSDK::EthernetNetwork.find_by(@client, name: ethernet[:name])
    ethernet2 = matches.first
    puts "\nFound ethernet-network by name: '#{ethernet[:name]}'.\n  uri = '#{ethernet2[:uri]}'"

    # Update purpose and smartLink settings from recently created network
    attributes = {
      purpose: 'Management',
      smartLink: true
    }

    ethernet2.update(attributes)
    puts "\nUpdated ethernet-network: '#{ethernet[:name]}'.\n  uri = '#{ethernet2[:uri]}'"
    puts "with attributes: #{attributes}"

    # Get associated profiles
    puts "\nSuccessfully retrieved associated profiles: #{ethernet2.get_associated_profiles}"

    # Get associated uplink groups
    puts "\nSuccessfully retrieved associated uplink groups: #{ethernet2.get_associated_uplink_groups}"

    # Retrieve recently created network
    ethernet3 = OneviewSDK::EthernetNetwork.new(@client, name: ethernet[:name])
    ethernet3.retrieve!
    puts "\nRetrieved ethernet-network data by name: '#{ethernet[:name]}'.\n  uri = '#{ethernet3[:uri]}'"

    # Example: List all ethernet networks with certain attributes
    attributes = { purpose: 'Management' }
    puts "\n\nEthernet networks with #{attributes}"
    OneviewSDK::EthernetNetwork.find_by(@client, attributes).each do |network|
      puts "  #{network[:name]}"
    end

    # Delete this network
    ethernet2.delete
    puts "\nSucessfully deleted ethernet-network '#{ethernet[:name]}'."
#=end
  end
end
