require File.expand_path(File.join(File.dirname(__FILE__), '..', 'login'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'fcoe_network'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_fcoe_network).provide(:ruby) do

  def initialize(*args)
      super(*args)
      @client = OneviewSDK::Client.new(login)
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::FCoENetwork.get_all(@client)
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

  def exists?
    state = resource['ensure'].to_s
    case state
    when 'present' then
      fcoe_network = get_fcoe_network(resource['data']['name'])
      fcoe_network_exists = false
      fcoe_network_exists = true if fcoe_network.first
      if fcoe_network_exists
        fcoe_network_update(resource['data'], fcoe_network, resource)
        return true
      end
    when 'absent' then
      # Resource itself sends the name of the running proccess
      fcoe_network = get_fcoe_network(resource['data']['name'])
      fcoe_network_exists = false
      fcoe_network_exists = true if fcoe_network.first
      return fcoe_network_exists
    when 'found' then
      fcoe_network = find_fcoe_networks(resource['data'])
      fcoe_network_exists = false
      fcoe_network_exists = true if fcoe_network
      return fcoe_network_exists
    end
    @property_hash[:ensure] == :present
  end

  def create
    data = data_parse(resource['data'])
    data.delete('new_name') if data['new_name']
    fcoe_network = OneviewSDK::FCoENetwork.new(@client, data).create
    @property_hash[:ensure] = :present
  end

  def destroy
    data = data_parse(resource['data'])
    fcoe_network = get_fcoe_network(data['name'])
    fcoe_network.first.delete
    @property_hash.clear
  end

  def found
    # Searches networks with data matching the manifest data
    data = data_parse(resource['data'])
    matches = OneviewSDK::FCoENetwork.find_by(@client, data)
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
