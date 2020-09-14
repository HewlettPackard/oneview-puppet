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

Puppet::Type.type(:oneview_logical_enclosure).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Logical Enclosures using the C7000 variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def exists?
    super
    @patch = @data.delete('patch')
    get_single_resource_instance.patch(@patch['op'], @patch['path'], @patch['value']) if @patch
    !@resource_type.find_by(@client, @data).empty?
  end

  def reapply_configuration
    Puppet.notice "\n\n-- Start reconfiguration"
    get_single_resource_instance.reconfigure
  end

  def get_script
    Puppet.notice "\n\n-- Start of the configuration script :"
    pretty get_single_resource_instance.get_script
    Puppet.notice "\n\n-- End of the configuration script."
    true
  end

  def set_script
    script = @data.delete('script')
    raise 'The "script" field is required inside data in order to use this ensurable' unless script
    get_single_resource_instance.set_script(script)
    true
  end

  def updated_from_group
    resource = get_single_resource_instance
    if resource.data['state'] == 'Inconsistent'
      Puppet.notice('Update from Group...')
      resource.update_from_group
    end
    true
  end

  def generate_support_dump
    dump = @data.delete('dump')
    raise 'The "dump" field is required inside data in order to use this ensurable' unless dump
    get_single_resource_instance.support_dump(dump)
  end
end
