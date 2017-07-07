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

Puppet::Type.type(:oneview_managed_san).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Managed SANs using the C7000 variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def self.resource_name
    'ManagedSAN'
  end

  # TODO: This is currently an implementation that does not work with 'puppet resource (...)' command. Revising it in the future would be
  # an improvement.
  def exists?
    prepare_environment
    resource['ensure'] == :present ? false : true
  end

  def create
    raise 'A "publicAttributes" or "sanPolicy" attribute is required to be set within data for this operation' unless
       @data['publicAttributes'] || @data['sanPolicy']
    public_attributes = @data.delete('publicAttributes')
    san_policy = @data.delete('sanPolicy')
    managed_san = get_single_resource_instance
    managed_san.set_public_attributes(public_attributes) if public_attributes
    managed_san.set_san_policy(san_policy) if san_policy
  end

  def destroy
    raise 'Absent is not a valid ensurable for this resource'
  end

  def get_zoning_report
    pretty get_single_resource_instance.get_zoning_report
    true
  end

  def get_endpoints
    pretty get_single_resource_instance.get_endpoints
    true
  end

  def set_refresh_state
    raise 'A refreshState is required to be set within data for this operation' unless @data['refreshState']
    refresh_state = @data.delete('refreshState')
    get_single_resource_instance.set_refresh_state(refresh_state)
    true
  end
end
