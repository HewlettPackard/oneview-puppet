require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'login'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_ethernet_network).provide(:ruby) do

  # Helper methods - TO BE REDEFINED

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    puts "Running #{resource}"
    # Puppet.notice("Connected to OneView appliance at #{@client.url}")
    @property_flush = {}
  end

  # def self.instances
  #   @client = OneviewSDK::Client.new(login)
  #   matches = OneviewSDK::EthernetNetwork.get_all(@client)
  #   matches.collect do |line|
  #     Puppet.notice("Ethernet Network: #{line['name']}, URI: #{line['uri']}")
  #   end
  # end

  # Provider methods

  # to do: decide whether an ethernet net can be created with a new name
  def exists?
    ethernet_network = get_ethernet_network(resource['data']['name'])
    ethernet_network_exists = false ; ethernet_network_exists = true if ethernet_network.first
    state = resource['ensure'].to_s

    # Checking for potential updates.
    if ethernet_network_exists && state != 'absent'
      ethernet_network_update(resource['data'], ethernet_network, resource) # resource itself sends the name of the running proccess
    end

    return ethernet_network_exists
  end

  def create
    data = data_parse(resource['data'])
    data.delete('new_name') if data['new_name']
    ethernet_network = OneviewSDK::EthernetNetwork.new(@client, data)
    ethernet_network.create
  end

  def destroy
    ethernet_network = get_ethernet_network(resource['data']['name'])
    ethernet_network.first.delete
  end

  def found
    # Pass on the attributes to find and search for a network with the specified attributes
    matches = OneviewSDK::EthernetNetwork.find_by(@client, name: resource['data']['name'])
    matches.first ? Puppet.notice("Found the network \'#{resource['data']['name']}\' (URI: #{matches.first.data['uri']}) on the system") : Puppet.notice("No networks with the name \'#{resource['data']['name']}\' were found on the system")
  end

end
