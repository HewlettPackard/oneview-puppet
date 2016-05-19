require 'oneview-sdk'

module Puppet::Parser::Functions
  newfunction(:ethernet_network_update) do |args|

    options = args[0] # to keep the sdk function as close as possible to original
    options.each { |key,value| options[key] = nil if value == 'nil' } ## Removes quotes from nil values inside the hash
    options.each { |key,value| options[key] = false if value == 'false' } ## Removes quotes from false values inside the hash

    attributes = args[1] # new attributes to be updated
    attributes.each { |key,value| attributes[key] = nil if value == 'nil' } ## Removes quotes from nil values inside the hash
    attributes.each { |key,value| attributes[key] = false if value == 'false' } ## Removes quotes from false values inside the hash

    network_exists = false
    matches = OneviewSDK::EthernetNetwork.find_by(@client, name: options['name'])
    network_exists = true if matches.first

    new_network_exists = false
    matches_new = OneviewSDK::EthernetNetwork.find_by(@client, name: attributes['name'])
    new_name_exists = true if matches_new.first

    puts "\nThere is no network currently named #{options['name']}.\n" if !network_exists

    puts "\nA network with the name #{attributes['name']} already exists.\n" if new_name_exists

    matches.first.update(attributes) if !new_name_exists
    puts "\nUpdated ethernet-network: '#{options["name"]}'.\n  uri = '#{matches.first[:uri]}'" if !new_name_exists
    puts "with attributes: #{attributes}" if !new_name_exists

  end
end
