################################################################################
# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
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

require_relative '../image_streamer_resource'

Puppet::Type::Image_streamer_plan_script.provide :synergy, parent: Puppet::ImageStreamerResource do
  desc 'Provider for Image Streamer Plan Scripts using the Synergy variant of the OneView API'

  confine true: login[:hardware_variant] == 'Synergy'

  mk_resource_methods

  def initialize(values)
    super
  end

  def exists?
    super([nil, :found, :retrieve_differences])
  end

  def retrieve_differences
    plan_script = get_single_resource_instance
    pretty plan_script.retrieve_differences
    true
  end
end
