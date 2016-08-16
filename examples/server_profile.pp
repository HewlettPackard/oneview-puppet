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

oneview_server_profile{'Server Profile Get Available Targets':
  ensure => 'get_available_networks'
}

# oneview_server_profile{'Server Profile Create':
#   ensure => 'present',
#   data   =>
#   {
#     name => 'Test Server Profile',
#     type => 'ServerProfileV5',
#     serverHardwareUri => '/rest/server-hardware/37333036-3831-584D-5131-303030323037',
#     # serverHardwareTypeUri => '/rest/server-hardware-types/1D614B25-4119-40F6-A71B-EAF01E325A3A',
#     # enclosureGroupUri => '/rest/enclosure-groups/961975e3-d160-411b-863e-732336850c3c'
#   }
# }
