require 'oneview-sdk'

Puppet::Type.type(:ethernet_network).provide(:ruby) do

  # Helper methods - TO BE REDEFINED

  def get_ethernet_network(name)
    @client = OneviewSDK::Client.new(
    url: 'https://172.16.101.19',
    user: 'Administrator',
    password: 'rainforest',
    ssl_enabled: false
    )
    Puppet.warning("Connected to the appliance #{@client.url}")
    matches = OneviewSDK::EthernetNetwork.find_by(@client, name: name)
    return matches
  end

  # Provider methods

  def exists?
    ethernet_network = get_ethernet_network(resource['attributes']['name'])
    ethernet_network_exists = false ; ethernet_network_exists = true if ethernet_network.first
    return ethernet_network_exists
  end

  def create
    options = resource['attributes']
    options.each { |key,value| options[key] = nil if value == 'nil' ; options[key] = false if value == 'false'}
    puts options
    ethernet_network = OneviewSDK::EthernetNetwork.new(@client, options)
    ethernet_network.create
  end

  def destroy
    ethernet_network = get_ethernet_network(resource['attributes']['name'])
    ethernet_network.first.delete
    Puppet.warning("Network destroyed")
  end


end
