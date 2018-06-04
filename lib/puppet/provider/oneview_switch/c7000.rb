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

Puppet::Type.type(:oneview_switch).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Switch resources using the C7000 variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def exists?
    dataless_ensure = [nil, :found, :get_type]
    super(dataless_ensure)
    return true if dataless_ensure.include?(resource['ensure'])
    !@resource_type.find_by(@client, unique_id).empty?
  end

  def create
    raise 'This ensurable is not supported for this resource'
  end

  def destroy
    super(:remove)
  end

  def get_type
    if @data['name']
      Puppet.notice "\n\n Search for switch type #{@data['name']} started, displaying results bellow:\n"
      results = @resource_type.get_type(@client, @data['name'])
      raise "\n\n No switch types corresponding to the name #{@data['name']} were found.\n" unless results
      pretty results
    else
      Puppet.notice "\n\n Search for switch types started, displaying results bellow:\n"
      pretty @resource_type.get_types(@client)
    end
    true
  end

  # Remove port_name from data hash for comparisons and usage
  def get_statistics
    port_name = @data.delete('port_name')
    pretty get_single_resource_instance.statistics(port_name)
    true
  end

  def get_environmental_configuration
    pretty get_single_resource_instance.environmental_configuration
    true
  end

  def set_scope_uris
    @scope_uris = @data.delete('scope_uris')
    pretty get_single_resource_instance.set_scope_uris(@scope_uris)
    true
  end
end
