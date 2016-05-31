require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'login'))
require 'oneview-sdk'

Puppet::Type.type(:ethernet_network).provide(:ruby) do

  # Helper methods - TO BE REDEFINED

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    puts "Running #{resource}"
    Puppet.notice("Connected to OneView appliance at #{@client.url}")
  end

  # Provider methods

  def exists?
    ethernet_network = get_ethernet_network(resource['attributes']['name'])
    ethernet_network_exists = false ; ethernet_network_exists = true if ethernet_network.first
    return ethernet_network_exists
  end

  def create
    attributes = attributes_parse(resource['attributes'])
    ethernet_network = OneviewSDK::EthernetNetwork.new(@client, attributes)
    ethernet_network.create
  end

  def destroy
    ethernet_network = get_ethernet_network(resource['attributes']['name'])
    ethernet_network.first.delete
  end


end
