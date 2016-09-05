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

# This sample scenario requires the following resources:
# - Server Hardware
# - Server Hardware Type

# oneview_server_hardware{'Server Hardware':
#   ensure => 'present',
#   data   => {
#     hostname        => '172.18.6.5',
#     username        => 'dcs',
#     password        => 'dcs',
#     licensingIntent => 'OneView'
#   },
# }
#
# oneview_server_hardware_type{'Server Hardware Type':
#     ensure  => 'present',
#     require => Oneview_server_hardware['Server Hardware'],
#     data    =>
#     {
#       name => 'BL460c Gen8 1'
#     }
# }
#
# oneview_logical_interconnect_group{'Logical Interconnect Group':
#   ensure  => 'present',
#   require => Oneview_server_hardware_type['Server Hardware Type'],
#   data    => {
#     name          => 'Puppet LIG',
#     enclosureType => 'C7000',
#     type          => 'logical-interconnect-groupV3',
#     interconnects =>
#     [
#       {
#         bay  => 1,
#         type => 'HP VC FlexFabric 10Gb/24-Port Module'
#       }
#     ]
#   }
# }

# oneview_enclosure_group{'Enclosure Group':
#   ensure => 'present',
#   # require => Oneview_logical_interconnect_group['Logical Interconnect Group'],
#   data   => {
#     name                        => 'Puppet Enclosure Group',
#     stackingMode                => 'Enclosure',
#     interconnectBayMappingCount => 1,
#     type                        => 'EnclosureGroupV200',
#     interconnectBayMappings     =>
#     [
#       {
#         interconnectBay             => 1,
#         logicalInterconnectGroupUri => 'Puppet LIG'
#       },
#       {
#         interconnectBay             => 2,
#         logicalInterconnectGroupUri => nil
#       },
#       {
#         interconnectBay             => 3,
#         logicalInterconnectGroupUri => nil
#       },
#       {
#         interconnectBay             => 4,
#         logicalInterconnectGroupUri => nil
#       },
#       {
#         interconnectBay             => 5,
#         logicalInterconnectGroupUri => nil
#       },
#       {
#         interconnectBay             => 6,
#         logicalInterconnectGroupUri => nil
#       },
#       {
#         interconnectBay             => 7,
#         logicalInterconnectGroupUri => nil
#       },
#       {
#         interconnectBay             => 8,
#         logicalInterconnectGroupUri => nil
#       },
#     ]
#   }
# }

# oneview_ethernet_network{'Ethernet Network':
#   ensure  => 'present',
#   require => Oneview_enclosure_group['Enclosure Group'],
#   data    =>
#   {
#     name           => 'Puppet Ethernet Network',
#     vlanId         => '1045',
#     purpose        => 'General',
#     smartLink      => true,
#     privateNetwork => false,
#     type           => 'ethernet-networkV3'
#   }
# }
#
# oneview_network_set{'Network Set':
#   ensure  => 'present',
#   require => Oneview_ethernet_network['Ethernet Network'],
#   data    =>
#   {
#     name        => 'Test Network Set',
#     networkUris => ['Puppet Ethernet Network']
#   }
# }

# oneview_server_profile_template{'Server Profile Template':
#   ensure  => 'present',
#   require => Oneview_network_set['Network Set'],
#   data    =>
#     {
#       name                  => 'Puppet Server Profile Template',
#       enclosureGroupUri     => 'Puppet Enclosure Group',
#       serverHardwareTypeUri => 'BL460c Gen8 1'
#     }
# }
#
# oneview_server_profile_template{'New Server Profile':
#   ensure  => 'set_new_profile',
#   require => Oneview_server_profile_template['Server Profile Template'],
#   data    =>
#   {
#     name              => 'Puppet Server Profile Template',
#     serverProfileName => 'Puppet Server Profile'
#   }
# }
#
oneview_server_profile{'Server Profile':
  ensure  => 'present',
  # require => Oneview_server_profile_template['New Server Profile'],
  data    =>
  {
    name => 'Puppet Server Profile',
    connections =>
    [
      {
        name         => 'My Connection',
        networkUri   => 'Test Network Set',
        functionType => 'Set',
      }
    ]
  }
}
#
# oneview_enclosure{'Enclosure':
#   ensure  => 'present',
#   require => Oneview_enclosure_group['Enclosure Group'],
#   data    =>
#   {
#     name              => 'Puppet_Enclosure',
#     hostname          => '172.18.1.13',
#     username          => 'dcs',
#     password          => 'dcs',
#     enclosureGroupUri => 'Puppet Enclosure Group',
#     licensingIntent   => 'OneView'
#   }
# }
#
# oneview_rack{'Rack':
#   ensure  => 'present',
#   require => Oneview_enclosure['Enclosure'],
#   data    =>
#   {
#     name       => 'myrack',
#     rackMounts =>
#     [
#       {
#         mountUri => 'Puppet_Enclosure, enclosure',
#         topUSlot => 20,
#         uHeight  => 10
#       }
#     ]
#   }
# }
#
# oneview_storage_system{'Storage System':
#   ensure  => 'present',
#   require => Oneview_rack['Rack'],
#   data    =>
#   {
#     managedDomain => 'TestDomain',
#     credentials   =>
#     {
#       ip_hostname => '172.18.11.12',
#       username    => 'dcs',
#       password    => 'dcs',
#     }
#   }
# }
#
# oneview_storage_pool{'Storage Pool':
#   ensure  => 'present',
#   require => Oneview_storage_system['Storage System'],
#   data    =>
#   {
#     poolName         => 'CPG-SSD-AO',
#     storageSystemUri => 'ThreePAR7200-8392'
#   }
# }
#
# oneview_volume{'Volume':
#   ensure  => 'present',
#   require => Oneview_storage_pool['Storage Pool'],
#   data    =>
#   {
#     name                   => 'Puppet Volume',
#     description            => 'Test volume with common creation: Storage System + Storage Pool',
#     snapshotPoolUri        => 'CPG-SSD-AO',
#     provisioningParameters =>
#     {
#       provisionType     => 'Full',
#       shareable         => true,
#       requestedCapacity => 1024 * 1024 * 1024,
#       storagePoolUri    => 'CPG-SSD-AO',
#     }
#   }
# }
