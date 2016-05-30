require 'oneview-sdk'

Puppet::Type.type(:ethernet_network).provide(:ruby) do

  # Helper methods

  def get_ethernet(name)
    @client = OneviewSDK::Client.new(
    url: 'https://172.16.101.19',
    user: 'Administrator',
    password: 'rainforest',
    ssl_enabled: false
    )
    Puppet.warning("Connected to the appliance #{@client.url}")
    matches = OneviewSDK::EthernetNetwork.find_by(@client, name: name)
    network_exists = false
    network_exists = true if matches.first
  end

  # Provider methods

  def exists?
    return get_ethernet(resource['name'])
  end

  def create
    Puppet.warning("Network created")
  end

  def destroy
    Puppet.warning("Network destroyed")
  end

end
