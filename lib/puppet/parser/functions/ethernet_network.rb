require 'oneview-sdk'

module Puppet::Parser::Functions
  newfunction(:ethernet_network) do |args|

    # COMMON VARIABLES / ASSIGNMENTS
    #===========================================================================
    action = args[0].downcase # getting CRUD action to be performed

    options = args[1] # to keep the sdk function as close as possible to original
    options.each { |key,value| options[key] = nil if value == 'nil' } ## Removes quotes from nil values inside the hash
    options.each { |key,value| options[key] = false if value == 'false' } ## Removes quotes from false values inside the hash

  if args[2]
    attributes = args[1] # new attributes to be updated
    attributes.each { |key,value| attributes[key] = nil if value == 'nil' } ## Removes quotes from nil values inside the hash
    attributes.each { |key,value| attributes[key] = false if value == 'false' } ## Removes quotes from false values inside the hash
  end

  network_exists = false
  matches = OneviewSDK::EthernetNetwork.find_by(@client, name: options['name'])
  network_exists = true if matches.first
  
  #===========================================================================

    case action # switching according to the action
    when "create"
      ethernet = OneviewSDK::EthernetNetwork.new(@client, options)
      ethernet.create unless ethernet.retrieve!
      puts "\nCreated ethernet-network '#{ethernet[:name]}' sucessfully.\n  uri = '#{ethernet[:uri]}'" if !network_exists

      puts "\nAn ethernet network named #{options['name']} already exists.\n" if network_exists # in case the ethernet network already exists

    when "find"


    when "create"

    when "create"

    else
      puts "#{action} is not a valid action."
    end

  end
end
