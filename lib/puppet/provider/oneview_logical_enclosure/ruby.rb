require File.expand_path(File.join(File.dirname(__FILE__), '..', 'login'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))
# require File.expand_path(File.join(File.dirname(__FILE__), '..', 'logical_enclosure'))
require 'oneview-sdk'

### FIXME: puppet parser is detecting an error on "Puppet::Type.type"
### not entirely sure why, but should be fixed once found out.
Puppet::Type.type(:oneview_logical_enclosure).provide(:ruby) do

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
    matches = OneviewSDK::LogicalEnclosure.get_all(@client)
    matches.collect do |line|
      # Puppet.notice("Logical Enclosure: #{line['name']}, URI: #{line['uri']}")
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

  # TODO: decide whether an fc net can be created with a new name
  def exists?
    # Gets the desired operation to perform
    state = resource['ensure'].to_s

    # Verify ensure flag and sets environment flags for operations
    case state
      when 'present' then
        # Resource itself sends the name of the running proccess
        logical_enclosure = OneviewSDK::LogicalEnclosure.new(@client, resource['data'])
        logical_enclosure.retrieve!
        puts "Retrieved logical-enclosure '#{logical_enclosure[:name]}' by name."
        logical_enclosure_exists = false
        logical_enclosure_exists = true if logical_enclosure
        puts "\n\nfalse\n\n" if !logical_enclosure_exists
        puts "\n\ntrue\n\n" if logical_enclosure_exists
        # Checking for and performing potential updates.
        if logical_enclosure_exists
          Puppet.notice("#{resource} '#{resource['data']['name']}' located"+
          " in Oneview Appliance")
          logical_enclosure_update(resource['data'], logical_enclosure, resource)
          return true
        end
      when 'absent' then
        # Resource itself sends the name of the running proccess
        logical_enclosure = get_logical_enclosure(resource['data']['name'])
        logical_enclosure_exists = false
        logical_enclosure_exists = true if logical_enclosure.first
        Puppet.notice("#{resource} '#{resource['data']['name']}' not located"+
        " in Oneview Appliance") if logical_enclosure_exists == false
        return logical_enclosure_exists
      when 'found' then
        true
    end
    # puts @property_hash[:data]
    @property_hash[:ensure] == :present
  end

  def create
    data = data_parse(resource['data'])
    data.delete('new_name') if data['new_name']
    logical_enclosure = OneviewSDK::LogicalEnclosure.new(@client, data)
    logical_enclosure.create
    @property_hash[:ensure] = :present
    @property_hash[:data] = data
  end

  def destroy
    logical_enclosure = get_logical_enclosure(resource['data']['name'])
    logical_enclosure.first.delete
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
    matches = OneviewSDK::LogicalEnclosure.find_by(@client, data)
    # If matches are found, iterate through them and notify. Else just notify.
    unless matches.empty?
      matches.each { |enclosure| Puppet.notice ( "\n\nFound logical enclosure"+
      "#{enclosure['name']} (URI: #{enclosure['uri']}) on Oneview Appliance\n")}
      true
    else
      Puppet.notice("\n\nNo logical enclosures with the specified data were"+
      " found on the Oneview Appliance\n")
      false
    end
  end

  def get_script
    # Prints the script currently applied to logical enclosure matching the
    # query
    data = data_parse(resource['data'])
    matches = OneviewSDK::LogicalEnclosure.find_by(@client, data)
    unless matches.empty?
      matches.each { |enclosure| Puppet.notice ( "\n\nFound logical enclosure"+
      " #{enclosure['name']} (URI: #{enclosure['uri']}) on Oneview Appliance\n")
      Puppet.notice ( "Its script contents are:\n#{enclosure.get_script}\n" )}
      true
    else
      Puppet.notice("\n\nNo logical enclosures with the specified data were"+
      " found on the Oneview Appliance\n")
      false
    end
  end

  def set_script
    # Prints the script currently applied to logical enclosure matching the
    # query
    data = data_parse(resource['data'])
    script = data['script'] if data['script']
    data.delete('script') if data['script']
    if script
      matches = OneviewSDK::LogicalEnclosure.find_by(@client, data)
      unless matches.empty?
        matches.each { |enclosure| Puppet.notice ( "\n\nFound logical enclosure"+
        " #{enclosure['name']} (URI: #{enclosure['uri']}) on Oneview Appliance\n")
        Puppet.notice ("Setting its script to:\n'#{script}'\n")
        enclosure.set_script(script)}
      else
        Puppet.notice("\n\nNo logical enclosures with the specified data were"+
        " found on the Oneview Appliance\n")
      end
    else
      Puppet.notice ( "\n\nThe 'script' field is required in data hash to run"+
      " the set_script option")
    end
  end

  def updated_from_group
    # Prints the script currently applied to logical enclosure matching the
    # query
    data = data_parse(resource['data'])
    matches = OneviewSDK::LogicalEnclosure.find_by(@client, data)
    unless matches.empty?
      matches.each { |enclosure| Puppet.notice ( "\n\nFound logical enclosure"+
      " #{enclosure['name']} (URI: #{enclosure['uri']}) on Oneview Appliance\n")
      Puppet.notice ( "Updating it from group...\n" )
      enclosure.update_from_group
      Puppet.notice ( "Logical enclosure #{enclosure['name']} updated.\n" )}
    else
      Puppet.notice("\n\nNo logical enclosures with the specified data were"+
      " found on the Oneview Appliance\n")
    end
  end

  def dumped
    # Prints the script currently applied to logical enclosure matching the
    # query
    data = data_parse(resource['data'])
    dump = data['dump'] if data['dump']
    data.delete('dump') if data['dump']
    matches = OneviewSDK::LogicalEnclosure.find_by(@client, data)
    unless matches.empty?
      matches.each { |enclosure| Puppet.notice ( "\n\nFound logical enclosure"+
      " #{enclosure['name']} (URI: #{enclosure['uri']}) on Oneview Appliance\n")
      enclosure.support_dump(dump)
      Puppet.notice ( "Generated dump for logical-enclosure "+
      "#{enclosure['name']}.\n" )}
    else
      Puppet.notice("\n\nNo logical enclosures with the specified data were"+
      " found on the Oneview Appliance\n")
    end
  end

end
