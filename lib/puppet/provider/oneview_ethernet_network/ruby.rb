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
  end

  # Provider methods

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
    ethernet_network = OneviewSDK::EthernetNetwork.new(@client, data)
    ethernet_network.create
  end

  def destroy
    ethernet_network = get_ethernet_network(resource['data']['name'])
    ethernet_network.first.delete
  end

end
