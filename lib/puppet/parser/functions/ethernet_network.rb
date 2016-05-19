require 'oneview-sdk'

module Puppet::Parser::Functions
  newfunction(:ethernet_network) do |args|

    # COMMON VARIABLES / ASSIGNMENTS
    #===========================================================================
    action = args[0].downcase # getting CRUD action to be performed

    options = args[1] # to keep the sdk function as close as possible to original
    options.each { |key,value| options[key] = nil if value == 'nil' } ## Removes quotes from nil values inside the hash
    options.each { |key,value| options[key] = false if value == 'false' } ## Removes quotes from false values inside the hash

    # Third set of values, only used in updates
    attributes_exist = false
    attributes_exist = true if args[2]
    attributes = args[2] if attributes_exist # new attributes to be updated
    attributes.each { |key,value| attributes[key] = nil if value == 'nil' } if attributes_exist ## Removes quotes from nil values inside the hash
    attributes.each { |key,value| attributes[key] = false if value == 'false' } if attributes_exist ## Removes quotes from false values inside the hash



    # Validates if a network with specified name exists
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
      puts "\nFound ethernet-network by name: '#{options["name"]}'.\n  uri = '#{matches.first[:uri]}'" if network_exists
      puts "\nAn ethernet network named '#{options['name']}' does not exist.\n" if !network_exists

    when "update"
      matches.first.update(attributes) if network_exists && attributes_exist
      puts "\n'attributes' not found. Please declare the attributes to be changed when using 'update'" if !attributes_exist
      puts "\nAn ethernet network named '#{options['name']}' does not exist.\n" if !network_exists
      puts "\nUpdated ethernet-network: '#{options["name"]}'.\n  uri = '#{matches.first[:uri]}'" if network_exists && attributes_exist
      puts "with attributes: #{attributes}\n" if network_exists && attributes_exist

    when "delete" # WARNING:: delete works but returns an unknown error. to be fixed. error is most likely to be in the puts below
      matches.first.delete if network_exists
      puts "\nDeleted ethernet-network '#{matches.first['name']}' successfully.\n" if network_exists
      puts "\nAn ethernet network named '#{options['name']}' does not exist.\n" if !network_exists

    else
      puts "#{action} is not a valid action."
    end

  end
end
