require File.expand_path(File.join(File.dirname(__FILE__), '..', 'login'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'enclosure_group'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_enclosure_group).provide(:ruby) do

  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
  end

  # def self.instances
  #   @client = OneviewSDK::Client.new(login)
  #   matches = OneviewSDK::EnclosureGroup.get_all(@client)
  #   matches.collect do |line|
  #     name = line['name']
  #     data = line.data
  #     new(  :name   => name,
  #           :ensure => :present,
  #           :data   => data
  #         )
  #   end
  # end

  def exists?
    state = resource['ensure']
    data = enclosure_group_parse(resource['data'])
    enclosure_group = OneviewSDK::EnclosureGroup.new(@client, name: data['name'])
    if enclosure_group.retrieve! && state == :present
      Puppet.notice("#{resource} '#{resource['data']['name']}' located"+
      " in Oneview Appliance")
      enclosure_group_update(data, enclosure_group, resource)
      true
    elsif enclosure_group.retrieve! && state == :absent
      true
    elsif state == :found
      true
    end
    # @property_hash[:ensure] == :present
  end

  def create
    data = enclosure_group_parse(resource['data'])
    data.delete('new_name') if data['new_name']
    enclosure_group = OneviewSDK::EnclosureGroup.new(@client, data)
    enclosure_group.create
    @property_hash[:ensure] = :present
    @property_hash[:data] = data
  end

  def destroy
    enclosure_group = get_enclosure_group(resource['data']['name'])
    enclosure_group.delete
    @property_hash.clear
  end

  def found
    # Searches networks with data matching the manifest data
    data = data_parse(resource['data'])
    matches = OneviewSDK::EnclosureGroup.find_by(@client, data)
    # If matches are found, iterate through them and notify. Else just notify.
    if matches
       matches.each { |network| Puppet.notice ( "\n\n Found matching network "+
      "#{network['name']} (URI: #{network['uri']}) on Oneview Appliance\n" ) }
      true
    else
      Puppet.notice("No networks with the specified data were found on the "+
      " Oneview Appliance")
      false
    end
  end

end
