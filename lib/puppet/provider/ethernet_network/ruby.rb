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

    # if ethernet_network_exists
    #   new_attributes = attributes_parse(resource['attributes'])
    #   puts new_attributes
    #   current = ethernet_network.first.data
    #   current.delete('modified')
    #   current['vlanId']=String(current['vlanId'])
    #   puts current
    #   current['vlanId'] = Integer(current['vlanId'])
    #   update = current.merge(new_attributes)
    #   update.delete('modified')
    #   puts update
    #   if update != current
    #     Puppet.warning("THIS IS DIFFERENT")
    #     Puppet.warning(update.to_a-current.to_a)
    #   end
    # end


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
