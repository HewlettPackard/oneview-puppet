require File.expand_path(File.join(File.dirname(__FILE__), '..', 'login'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'ethernet_network'))
require 'oneview-sdk'

### FIXME: puppet parser is detecting an error on "Puppet::Type.type"
### not entirely sure why, but should be fixed once found out.
Puppet::Type.type(:oneview_ethernet_network).provide(:ruby) do

  # Helper methods - TO BE REDEFINED
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    # puts "Running #{resource}"
    # Puppet.notice("Connected to OneView appliance at #{@client.url}")
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::EthernetNetwork.get_all(@client)
    matches.collect do |line|
      # Puppet.notice("Ethernet Network: #{line['name']}, URI: #{line['uri']}")
      name = line['name']
      data = line.inspect
      new(:name   => name,
          :ensure => :present,
          :data   => data
          )
    end
  end

  def self.prefetch(resources)
    packages = instances
    resources.keys.each do |name|
      if provider = packages.find{ |pkg| pkg.name == name }
        resources[name].provider = provider
      end
    end
  end

  # Provider methods

  # to do: decide whether an ethernet net can be created with a new name
  def exists?
    # Gets the desired operation to perform
    state = resource['ensure'].to_s

    # Verify ensure flag and sets environment flags for operations
    case state
      when 'present' then
        # Resource itself sends the name of the running proccess
        ethernet_network = get_ethernet_network(resource['data']['name'])
        ethernet_network_exists = false
        ethernet_network_exists = true if ethernet_network.first
        # Checking for and performing potential updates.
        if ethernet_network_exists
          Puppet.notice("#{resource} '#{resource['data']['name']}' located"+
          " in Oneview Appliance")
          ethernet_network_update(resource['data'], ethernet_network, resource)
          return true
        end
      when 'absent' then
        # Resource itself sends the name of the running proccess
        ethernet_network = get_ethernet_network(resource['data']['name'])
        ethernet_network_exists = false
        ethernet_network_exists = true if ethernet_network.first
        Puppet.notice("#{resource} '#{resource['data']['name']}' not located"+
        " in Oneview Appliance") if ethernet_network_exists == false
        return ethernet_network_exists
      when 'found' then
        ethernet_network = find_ethernet_networks(resource['data'])
        ethernet_network_exists = false
        ethernet_network_exists = true if ethernet_network
        return ethernet_network_exists
    end
    # puts @property_hash[:data]
    @property_hash[:ensure] == :present
  end

  def create
    data = data_parse(resource['data'])
    data.delete('new_name') if data['new_name']
    ethernet_network = OneviewSDK::EthernetNetwork.new(@client, data)
    ethernet_network.create
    @property_hash[:ensure] = :present
    @property_hash[:data] = data
  end

  def destroy
    ethernet_network = get_ethernet_network(resource['data']['name'])
    ethernet_network.first.delete
    @property_hash.clear
  end

  def data
    @property_hash[:data]
  end

  def data=(value)
    @property_hash[:data] = value
  end


  def found
    # Searches networks with data matching the manifest data
    data = data_parse(resource['data'])
    matches = OneviewSDK::EthernetNetwork.find_by(@client, data)
    # If matches are found, iterate through them and notify. Else just notify.
    if matches
       matches.each { |network| Puppet.notice ( "\n\n Found matching network "+
      "#{network['name']} (URI: #{network['uri']}) on Oneview Appliance\n" ) }
      return true
    else
      Puppet.notice("No networks with the specified data were found on the "+
      " Oneview Appliance")
      return false
    end
  end

end
