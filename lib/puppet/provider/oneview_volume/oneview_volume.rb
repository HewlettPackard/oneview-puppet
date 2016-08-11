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

Puppet::Type.type(:oneview_volume).provide(:oneview_volume) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::Volume
    # Initializes the data so it is parsed only on exists and accessible throughout the methods
    # This is not set here due to the 'resources' variable not being accessible in initialize
    @data = {}
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::Volume.find_by(@client, {})
    matches.collect do |line|
      name = line['name']
      data = line.inspect
      new(name: name,
          ensure: :present,
          data: data)
    end
  end

  # Provider methods
  def exists?
    @data = data_parse
    empty_data_check([:found, :get_attachable_volumes, :get_extra_managed_volume_paths])
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    return true if resource_update(@data, @resourcetype)
    @resourcetype.new(@client, @data).create
    @property_hash[:ensure] = :present
    @property_hash[:data] = @data
    true
  end

  def destroy
    get_single_resource_instance.delete
    @property_hash.clear
    true
  end

  def found
    find_resources
  end

  def get_attachable_volumes
    Puppet.notice "\n Getting attachable volumes...\n"
    Puppet.notice "\n Displaying list of attachable volumes bellow:\n"
    pretty @resourcetype.get_attachable_volumes(@client)
    Puppet.notice "\n <End of the list of attachable volumes>\n"
    true
  end

  def get_extra_managed_volume_paths
    Puppet.notice "\n Getting extra managed volume paths...\n"
    Puppet.notice "\n Displaying list of extra managed volume paths bellow:\n"
    pretty @resourcetype.get_extra_managed_volume_paths(@client)
    Puppet.notice "\n <End of the list of attachable volumes>\n"
    true
  end

  def repair
    Puppet.notice "\n Removing extra presentations from specified volume... \n"
    get_single_resource_instance.repair
    true
  end

  def create_snapshot
    snapshot_parameters ||= @data.delete('snapshotParameters')
    get_single_resource_instance.create_snapshot(snapshot_parameters)
    Puppet.notice "\n\n Snapshot Created Successfully. \n"
    true
  end

  def delete_snapshot
    raise 'A "snapshotParameters" tag is required to be set within data for this operation.' unless @data['snapshotParameters']
    snapshot_parameters ||= @data.delete('snapshotParameters')
    raise 'A "name" tag is required to be set within snapshotParameters for this operation.' unless snapshot_parameters['name']
    get_single_resource_instance.delete_snapshot(snapshot_parameters['name'])
    Puppet.notice "\n\n Snapshot Deleted Successfully. \n"
    true
  end

  def get_snapshot
    snapshot_parameters ||= @data.delete('snapshotParameters')
    if snapshot_parameters
      raise 'A snapshot Parameter "name" is required when the snapshotParameters is used for this operation' unless
        snapshot_parameters['name']
      pretty get_single_resource_instance.get_snapshot(snapshot_parameters['name'])
    else
      pretty get_single_resource_instance.get_snapshots
    end
    true
  end
end
