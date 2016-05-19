require 'oneview-sdk'

module Puppet::Parser::Functions
  newfunction(:ethernet_network_find) do |args|

    options = args[0]

    options.each { |key,value| options[key] = nil if value == 'nil' } ## Removes quotes from nil values inside the hash
    options.each { |key,value| options[key] = false if value == 'false' } ## Removes quotes from false values inside the hash

    network_exists = false
    matches = OneviewSDK::EthernetNetwork.find_by(@client, name: options['name'])
    network_exists = true if matches.first

    puts "\nFound ethernet-network by name: '#{options["name"]}'.\n  uri = '#{matches.first[:uri]}'" if network_exists
    puts "\nThere is no ethernet network named #{options['name']}.\n" if !network_exists

  end
end
