################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'login'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_volume_attachment).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::VolumeAttachment
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::VolumeAttachment.get_all(@client)
    matches.collect do |line|
      name = line['name']
      data = line.inspect
      new(name: name,
          ensure: :present,
          data: data
         )
    end
  end

  # TODO: eventually implement this prefetch method as it seems useful but requires an investigation into it
  # def self.prefetch(resources)
  #   packages = instances
  #   resources.keys.each do |name|
  #     if provider = packages.find { |pkg| pkg.name == name }
  #       resources[name].provider = provider
  #     end
  #   end
  # end

  def pretty(arg)
    return puts arg if arg.instance_of?(String)
    puts JSON.pretty_generate(arg)
  end

  # Provider methods

  def exists?
    state = resource['ensure'].to_s
    # # TODO: This validation should be run on the "type" itself
    # # In case it is not, this part of the code should be enabled
    # # Verify if data is set for resources that need it, else fail
    # unless resource['data'] || (state == 'found')
    #   fail("A 'data' Hash is required for the present operation")
    # end
    # TODO: This method at the moment only has gets, CRUD operations are disabled at SDK
    # This code should be revisited and enabled/tested in case CRUD operations
    # data = data_parse
    # volume_attachment = if state == 'present'
    #                     resource_update(data, @resourcetype)
    #                     OneviewSDK::VolumeAttachment.find_by(@client, name: data['name'])
    #                   else
    #                     OneviewSDK::VolumeAttachment.find_by(@client, data)
    #                   end
    # # Puppet.notice("#{resource} '#{data['name']}' located in Oneview Appliance") unless volume_attachment.empty? || !data['name']
    # !volume_attachment.empty?
    # This if makes it so present and absent states never run
    if state == 'absent'
      false
    else
      true
    end
  end

  def create
    Puppet.notice("Ensure state 'present' is unavailable for resource '#{resource}") # unless volume_attachment.empty? || !data['name']
    # data = data_parse
    # volume_attachment = @resourcetype.new(@client, data)
    # volume_attachment.create
    # @property_hash[:ensure] = :present
    # @property_hash[:data] = data
  end

  def destroy
    Puppet.notice("Ensure state 'absent' is unavailable for resource '#{resource}") # unless volume_attachment.empty? || !data['name']
    # data = data_parse
    # volume_attachment = @resourcetype.find_by(@client, name: data['name']).first
    # if volume_attachment
    #   volume_attachment.delete
    # else
    #   Puppet.notice("#{resource} '#{data['name']}' not located in Oneview Appliance")
    # end
    # @property_hash.clear
  end

  def found
    # Searches VolumeAttachments with data matching the manifest data
    data = data_parse
    retrieved_resource = @resourcetype.find_by(@client, data)
    # If resources are found, iterate through them and notify. Else just notify.
    if !retrieved_resource.empty?
      retrieved_resource.each do |volume_attachment|
        Puppet.notice "\n\n Found matching volume attachment #{volume_attachment['hostName']} "\
        "(URI: #{volume_attachment['uri']}) on Oneview Appliance\n"
      end
      true
    else
      Puppet.notice("\n\n No volume attachments with the specified data were found on "\
      "the Oneview Appliance\n")
      false
    end
  end

  def get_extra_unmanaged_volumes
    # List extra unmanaged storage volumes
    extra_managed_volumes = @resourcetype.get_extra_unmanaged_volumes(@client)['members']
    if extra_managed_volumes.empty?
      Puppet.notice("\n\nNo Unmanaged volumes were found on the appliance.\n\n")
    else
      Puppet.notice("\n\nUnmanaged volumes:\n\n")
      extra_managed_volumes.each do |unmanaged_volume|
        Puppet.notice("\n- #{unmanaged_volume['ownerUri']}\n")
      end
    end
  end

  def remove_extra_unmanaged_volume
    data = data_parse
    # Removes extra unmanaged volumes from a server profile
    server_profile = OneviewSDK::ServerProfile.find_by(@client, name: data['name']).first
    if server_profile
      @resourcetype.remove_extra_unmanaged_volume(@client, server_profile['uri'])
    else
      Puppet.err("\n\nSpecified Server Profile does not exist.\n\n")
    end
  end

  def get_paths
    data = data_parse
    # List extra unmanaged storage volumes
    id ||= id_helper(data)
    retrieved_resource = @resourcetype.find_by(@client, data).first
    if retrieved_resource
      if id
        get_path_by_id(retrieved_resource)
      else
        get_all_paths(retrieved_resource)
      end
    else
      Puppet.err("\n\nSpecified Storage Volume Attachment does not exist\n\n") unless retrieved_resource
      # fail 'Specified Storage Volume Attachment does not exist' unless retrieved_resource
    end
  end

  def id_helper(data)
    # helper for get_path
    return unless data['id']
    id = data['id']
    data.delete('id')
    id
  end

  def get_path_by_id(retrieved_resource)
    volume_path = retrieved_resource.get_path(id)
    if volume_path
      Puppet.notice("\n\nPath from attachment with id #{id}: \n#{volume_path} \n\n")
    else
      Puppet.notice("\n\nNo Storage Volume Attachment Paths found with id #{id} on #{retrieved_resource['name']}\n\n")
    end
  end

  def get_all_paths(retrieved_resource)
    volume_paths = retrieved_resource.get_paths
    if !volume_paths.empty?
      Puppet.notice("\n\nPaths from storage attachment #{retrieved_resource['name']}:\n")
      volume_paths.each do |path|
        Puppet.notice("- #{path['initiatorName']}")
      end
    else
      Puppet.notice("\n\nNo Storage Volume Attachment Paths found with on #{retrieved_resource['name']}\n\n")
    end
  end
end
