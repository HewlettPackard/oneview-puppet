################################################################################
# (C) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
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

require_relative '../oneview_resource'

Puppet::Type.type(:oneview_drive_enclosure).provide :synergy, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Drive Enclosures using the Synergy variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'Synergy'

  mk_resource_methods

  def initialize(values)
    super
    @patch = {}
  end

  def exists?
    super
    return true if @data.empty?
    perform_patch
    @resource_type.new(@client, @data).exists?
  end

  def create
    raise 'This resource cannot be created directly.'
  end

  def destroy
    raise 'This resource cannot be destroyed directly.'
  end

  def perform_patch
    @patch = @data.delete('patch')
    return unless @patch
    Puppet.notice('Performing Patch operation on Drive Enclosure...')
    get_single_resource_instance.patch(@patch['op'], @patch['path'], @patch['value'])
    Puppet.notice('Patch operation completed.')
  end

  def set_refresh_state
    raise 'A "refreshState" tag is required within data for the current operation.' unless @data['refreshState']
    refresh_state = @data.delete('refreshState')
    get_single_resource_instance.set_refresh_state(refresh_state)
    true
  end
end
