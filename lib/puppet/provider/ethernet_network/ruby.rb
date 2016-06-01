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
    state = resource['ensure'].to_s

    # Checking for potential updates. OBS: data = new attributes from the manifest, may have updates
    if ethernet_network_exists && state != 'absent'
      data = attributes_parse(resource['attributes'])                               # new data to be checked for changes
      existing_ethernet_network = ethernet_network.first.data
      if data['vlanId'].to_s != existing_ethernet_network['vlanId'].to_s            # checks whether the vlanId has been changed
        Puppet.warning("Update operation does not support vlanId changing, ignoring...")
      end
      data.delete('connectionTemplateUri') if data['connectionTemplateUri'] == nil  # the connectionTemplateUri can only be nil at its creation
      data.delete('vlanId') if data['vlanId']                                       # in case a new vlanId exists, as it cannot be changed
      data.delete('modified')                                                       # field not considered for comparison
      updated_data = existing_ethernet_network.merge(data)                          # new hash / difference between old and new ones
      if updated_data != existing_ethernet_network                                  # if there's any difference...
      	updated_data = Hash[updated_data.to_a-existing_ethernet_network.to_a]       # hash with different attributes remaining
      	ethernet_network.first.update(updated_data)                                 # the actual update on the
      	Puppet.warning("Updated: #{updated_data.inspect} ")                         # shows what
      end
    end

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
