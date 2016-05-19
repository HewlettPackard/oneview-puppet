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
      puts "\nFound ethernet-network by name: '#{options["name"]}'.\n  uri = '#{matches.first[:uri]}'" if network_exists
      puts "\nThere is no ethernet network named #{options['name']}.\n"                                if !network_exists

    # when "update"

  when "delete" # WARNING:: delete works but returns an unknown error. to be fixed. error is most likely to be in the puts below
      if network_exists
        matches.first.delete
        # puts "\nDeleted ethernet-network '#{matches.first['name']}' successfully.\n"
      else
        # puts "\nThere is no ethernet network named #{matches.first['name']}.\n"
      end

    else
      puts "#{action} is not a valid action."
    end

  end
end
