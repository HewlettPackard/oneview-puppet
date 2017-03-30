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

Puppet::Type.type(:oneview_san_manager).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView SAN Manager using the C7000 variant of the OneView API'

  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def exists?
    @data = data_parse
    parse_provider_uri
    empty_data_check
    @resource_type.find_by(@client, @data).any?
  end

  def create
    super(:add)
  end

  def destroy
    super(:remove)
  end

  def parse_provider_uri
    return unless @data['providerUri']
    return if @data['providerUri'].to_s[0..6].include?('/rest/')
    @data['providerDisplayName'] = @data.delete('providerUri')
  end

  def resource_name
    'SANManager'
  end

  def self.resource_name
    'SANManager'
  end
end
