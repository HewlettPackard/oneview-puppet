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

Puppet::Type::Oneview_switch.provide :synergy, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Switch resources using the Synergy variant of the OneView API'

  confine true: login[:hardware_variant] == 'Synergy'

  mk_resource_methods

  def exists?
    @data = data_parse
    true
  end

  def create
    raise 'Method unavailable for Synergy'
  end

  def destroy
    raise 'Method unavailable for Synergy'
  end

  def get_type
    if @data['name']
      Puppet.notice "\n\n Search for switch type #{@data['name']} started, displaying results bellow:\n"
      results = @resourcetype.get_type(@client, @data['name'])
      raise "\n\n No switch types corresponding to the name #{@data['name']} were found.\n" unless results
      pretty results
    else
      Puppet.notice "\n\n Search for switch types started, displaying results bellow:\n"
      pretty @resourcetype.get_types(@client)
    end
    true
  end

  # Remove port_name and subport_number from data hash for comparisons and usage
  def get_statistics
    raise 'Method unavailable for Synergy'
  end

  def get_environmental_configuration
    raise 'Method unavailable for Synergy'
  end

  def set_scope_uris
    raise 'Method unavailable for Synergy'
  end
end
