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

Puppet::Type.type(:oneview_sas_interconnect).provide :synergy, parent: Puppet::OneviewResource do
  desc 'Provider for OneView SAS Interconnects using the Synergy variant of the OneView API'

  confine true: login[:hardware_variant] == 'Synergy'

  mk_resource_methods

  def resource_name
    'SASInterconnect'
  end

  def self.resource_name
    'SASInterconnect'
  end

  def exists?
    @data = data_parse
    empty_data_check([nil, :found, :get_types])
    return !@resource_type.find_by(@client, @data).empty? if @data.empty?
    variable_assignments
    get_single_resource_instance.patch(@patch['op'], @patch['path'], @patch['value']) if @patch
    @resource_type.new(@client, @data).exists?
  end

  def create
    raise('This resource relies on others to be created.')
  end

  def destroy
    raise('This resource relies on others to be destroyed.')
  end

  def get_types
    Puppet.notice("\n\nSASInterconnect Types\n")
    if @data['name']
      pretty @resource_type.get_type(@client, @data['name'])
    else
      pretty @resource_type.get_types(@client)
    end
    true
  end

  def set_refresh_state
    raise 'A "refreshState" tag is required within data for the current operation.' unless @refresh_state
    get_single_resource_instance.set_refresh_state(@refresh_state)
    true
  end

  # Helpers

  def variable_assignments
    @patch = @data.delete('patch')
    @refresh_state = @data.delete('refreshState')
  end
end
