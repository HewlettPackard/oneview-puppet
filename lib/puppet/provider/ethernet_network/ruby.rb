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

    # Checking for potential updates
    if ethernet_network_exists && resource['ensure'].to_s != 'absent'
      new_attributes = attributes_parse(resource['attributes'])
      new_attributes.delete('connectionTemplateUri') if new_attributes['connectionTemplateUri'] == nil
      current = ethernet_network.first.data
      current.delete('modified')
      current['vlanId'] = String(current['vlanId'])
      update = current.merge(new_attributes)
      update.delete('modified')
      if update != current
        update = Hash[update.to_a-current.to_a]
        ethernet_network.first.update(update)
        Puppet.warning("Updated: #{update.inspect} ")
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
