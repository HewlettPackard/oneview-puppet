require 'oneview-sdk'

module Puppet::Parser::Functions
  newfunction(:ethernet_network_update) do |args|

    options = args[0] # to keep the sdk function as close as possible to original
    options.each { |key,value| options[key] = nil if value == 'nil' } ## Removes quotes from nil values inside the hash
    options.each { |key,value| options[key] = false if value == 'false' } ## Removes quotes from false values inside the hash

    attributes = args[1] # new attributes to be updated
    attributes.each { |key,value| attributes[key] = nil if value == 'nil' } ## Removes quotes from nil values inside the hash
    attributes.each { |key,value| attributes[key] = false if value == 'false' } ## Removes quotes from false values inside the hash


    matches = OneviewSDK::EthernetNetwork.find_by(@client, name: options['name'])
    ethernet2 = matches.first # Checks whether the previously created ethernet exists

    matches = OneviewSDK::EthernetNetwork.find_by(@client, name: attributes['name'])
    ethernet3 = matches.first # Checks whether an ethernet with the new given name exists

    if !ethernet2 # The current ethernet has to exist
      puts "\nThere is no network currently named #{options['name']}.\n"
    elsif ethernet3 # The new name cannot be equal to an existing network's name
      puts "\nA network with the name #{attributes['name']} already exists.\n"
    else
      ethernet2.update(attributes)
      puts "\nUpdated ethernet-network: '#{options["name"]}'.\n  uri = '#{ethernet2[:uri]}'"
      puts "with attributes: #{attributes}"
    end

  end
end
