require File.expand_path(File.join(File.dirname(__FILE__), '..', 'login'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'ethernet_network'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_ethernet_network).provide(:ruby) do

  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
  end

  def exists?
    state = resource['ensure']
    data = data_parse(resource['data'])

    #skips all steps but creation in case of a bulk request
    is_bulk = true if data['vlanIdRange']
    return false if is_bulk == true

    # to be used in FOUND
    if data['name']
      ethernet_network = OneviewSDK::EthernetNetwork.new(@client, name: data['name'])
    elsif data['vlanId']
      ethernet_network = OneviewSDK::EthernetNetwork.new(@client, name: data['vlanId'])
    end

    if ethernet_network.retrieve! && state == :present
      Puppet.notice("#{resource} '#{resource['data']['name']}' located"+
      " in Oneview Appliance")
      ethernet_network_update(data, ethernet_network, resource)
      true
    elsif ethernet_network.retrieve! && state == :absent
      true
    elsif state == :found
      true
    else
      false
    end

  end

  def create
    data = data_parse(resource['data'])
    is_bulk = true if data['vlanIdRange']
    data.delete('new_name') if data['new_name']
    if is_bulk
      bulk_data = bulk_parse(data)
      puts bulk_data
      # ethernet_network = OneviewSDK::EthernetNetwork.bulk_create(@client, data)
    else
      ethernet_network = OneviewSDK::EthernetNetwork.new(@client, data)
      ethernet_network.create
    end
  end

  def destroy
    ethernet_network = get_ethernet_network(resource['data']['name'])
    ethernet_network.first.delete
    @property_hash.clear
  end

  def found
    # Searches networks with data matching the manifest data
    data = data_parse(resource['data'])
    matches = OneviewSDK::EthernetNetwork.find_by(@client, data)
    # If matches are found, iterate through them and notify. Else just notify.
    unless matches.empty?
       matches.each { |network| Puppet.notice ( "\n\n Found matching network "+
      "#{network['name']} (URI: #{network['uri']}) on Oneview Appliance\n" ) }
      true
    else
      Puppet.notice("\n\n No networks with the specified data were found on the "+
      " Oneview Appliance\n")
      false
    end
  end


end
