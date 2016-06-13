require File.expand_path(File.join(File.dirname(__FILE__), '..', 'login'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'enclosure_group'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_enclosure_group).provide(:ruby) do

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
  end

  def self.instances
  end

  def exists?
    state = resource['ensure']
    data = enclosure_group_parse(resource['data'])
    enclosure_group = OneviewSDK::EnclosureGroup.new(@client, name: data['name'])
    if enclosure_group.retrieve! && state == :present
      enclosure_group_update(data, enclosure_group, resource)
      true
    elsif enclosure_group.retrieve! && state == :absent
      true
    end
  end

  def create
    data = enclosure_group_parse(resource['data'])
    data.delete('new_name') if data['new_name']
    enclosure_group = OneviewSDK::EnclosureGroup.new(@client, data)
    enclosure_group.create
    @property_hash[:ensure] = :present
  end

  def destroy
    enclosure_group = get_enclosure_group(resource['data']['name'])
    enclosure_group.delete
    @property_hash.clear
  end

end
