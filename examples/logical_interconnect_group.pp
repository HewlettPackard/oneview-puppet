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

# This example uses the compact syntax (not api standard) to create a Logical interconnect group with its uplink sets, networkuris and
  # internalNetworkUris. It should be simpler than passing all the information required to do so usually.
oneview_logical_interconnect_group{'Puppet LIG C7000 Simplified':
  ensure => 'present',
  data   => {
    'name'                => 'PUPPET_TEST_LIG',
    'type'                => 'logical-interconnect-groupV300',
    'enclosureType'       => 'C7000',
    'state'               => 'Active',
    'uplinkSets'          => [
      {
        'name'                => 'TUNNEL_ETH_UP_01',
        'ethernetNetworkType' => 'Tunnel',
        'networkType'         => 'Ethernet',
        'lacpTimer'           => 'Short',
        'mode'                => 'Auto',
        'uplink_ports'        => [{ bay  => 1,
                                    port => 'X5' },
                                  { bay  => 1,
                                    port => 'X6' },
                                  { bay  => 2,
                                    port => 'X7' },
                                  { bay  => 2,
                                    port => 'X8' }
                                    ],
        'networkUris'         => [
          'tunnelnet1'
        ]
      }
    ],
    'interconnects'       => [
      { bay  => 1,
        type => 'HP VC FlexFabric 10Gb/24-Port Module' },
      { bay  => 2,
        type => 'HP VC FlexFabric 10Gb/24-Port Module' }
        ],
    'internalNetworkUris' => ['test']
  },
}

# This example creates a Logical Interconnect Group, with a similar structure to the one listed above, but using a more typical API payload.
oneview_logical_interconnect_group{'Puppet LIG C7000 Full':
  ensure => 'present',
  data   => {
    'type'                    => 'logical-interconnect-groupV300',
    'name'                    => 'ONEVIEW_SDK_TEST_LIG',
    'enclosureType'           => 'C7000',
    'state'                   => 'Active',
    'uplinkSets'              => [
      {
        'name'                   => 'TUNNEL_ETH_UP_01',
        'ethernetNetworkType'    => 'Tunnel',
        'networkType'            => 'Ethernet',
        'logicalPortConfigInfos' => [
          {
            'desiredSpeed'    => 'Auto',
            'logicalLocation' => {
              'locationEntries' => [
                {
                  'relativeValue' => 1,
                  'type'          => 'Bay'
                },
                {
                  'relativeValue' => 1,
                  'type'          => 'Enclosure'
                },
                {
                  'relativeValue' => 21,
                  'type'          => 'Port'
                }
              ]
            }
          },
          {
            'desiredSpeed'    => 'Auto',
            'logicalLocation' => {
              'locationEntries' => [
                {
                  'relativeValue' => 1,
                  'type'          => 'Bay'
                },
                {
                  'relativeValue' => 1,
                  'type'          => 'Enclosure'
                },
                {
                  'relativeValue' => 22,
                  'type'          => 'Port'
                }
              ]
            }
          },
          {
            'desiredSpeed'    => 'Auto',
            'logicalLocation' => {
              'locationEntries' => [
                {
                  'relativeValue' => 2,
                  'type'          => 'Bay'
                },
                {
                  'relativeValue' => 1,
                  'type'          => 'Enclosure'
                },
                {
                  'relativeValue' => 23,
                  'type'          => 'Port'
                }
              ]
            }
          },
          {
            'desiredSpeed'    => 'Auto',
            'logicalLocation' => {
              'locationEntries' => [
                {
                  'relativeValue' => 2,
                  'type'          => 'Bay'
                },
                {
                  'relativeValue' => 1,
                  'type'          => 'Enclosure'
                },
                {
                  'relativeValue' => 24,
                  'type'          => 'Port'
                }
              ]
            }
          }
        ],
        'lacpTimer'              => 'Short',
        'mode'                   => 'Auto',
        'networkUris'            => [
          '/rest/ethernet-networks/eca5f86a-2936-44c7-b3e1-8b1e01c89426'
        ]
      }
    ],
    'interconnectMapTemplate' => {
      'interconnectMapEntryTemplates' => [
        {
          'logicalLocation'              => {
            'locationEntries' => [
              {
                'relativeValue' => 1,
                'type'          => 'Bay'
              },
              {
                'relativeValue' => 1,
                'type'          => 'Enclosure'
              }
            ]
          },
          'permittedInterconnectTypeUri' => '/rest/interconnect-types/005ef42f-eb2e-44ff-bc6d-d736d1705f72'
        },
        {
          'logicalLocation'              => {
            'locationEntries' => [
              {
                'relativeValue' => 2,
                'type'          => 'Bay'
              },
              {
                'relativeValue' => 1,
                'type'          => 'Enclosure'
              }
            ]
          },
          'permittedInterconnectTypeUri' => '/rest/interconnect-types/005ef42f-eb2e-44ff-bc6d-d736d1705f72'
        },
        {
          'logicalLocation' => {
            'locationEntries' => [
              {
                'relativeValue' => 3,
                'type'          => 'Bay'
              },
              {
                'relativeValue' => 1,
                'type'          => 'Enclosure'
              }
            ]
          },
        },
        {
          'logicalLocation' => {
            'locationEntries' => [
              {
                'relativeValue' => 4,
                'type'          => 'Bay'
              },
              {
                'relativeValue' => 1,
                'type'          => 'Enclosure'
              }
            ]
          },
        },
        {
          'logicalLocation' => {
            'locationEntries' => [
              {
                'relativeValue' => 5,
                'type'          => 'Bay'
              },
              {
                'relativeValue' => 1,
                'type'          => 'Enclosure'
              }
            ]
          },
        },
        {
          'logicalLocation' => {
            'locationEntries' => [
              {
                'relativeValue' => 6,
                'type'          => 'Bay'
              },
              {
                'relativeValue' => 1,
                'type'          => 'Enclosure'
              }
            ]
          },
        },
        {
          'logicalLocation' => {
            'locationEntries' => [
              {
                'relativeValue' => 7,
                'type'          => 'Bay'
              },
              {
                'relativeValue' => 1,
                'type'          => 'Enclosure'
              }
            ]
          },
        },
        {
          'logicalLocation' => {
            'locationEntries' => [
              {
                'relativeValue' => 8,
                'type'          => 'Bay'
              },
              {
                'relativeValue' => 1,
                'type'          => 'Enclosure'
              }
            ]
          },
        }
      ]
    }
  }
}


oneview_logical_interconnect_group{'Logical Interconnect Group Found':
  ensure  => 'found',
}

oneview_logical_interconnect_group{'Logical Interconnect Group Get Default Settings':
  ensure  => 'get_default_settings',
  require => Oneview_logical_interconnect_group['Logical Interconnect Group Found'],
  data    => {
    name => 'PUPPET_TEST_LIG'
  }
}

oneview_logical_interconnect_group{'Logical Interconnect Group Get Settings':
  ensure  => 'get_settings',
  require => Oneview_logical_interconnect_group['Logical Interconnect Group Get Default Settings'],
  data    => {
    name => 'PUPPET_TEST_LIG'
  }
}

oneview_logical_interconnect_group{'Logical Interconnect Group Destroy Oneview SDK':
  ensure => 'absent',
  data   => {
    name => 'ONEVIEW_SDK_TEST_LIG'
  }
}

oneview_logical_interconnect_group{'Logical Interconnect Group Destroy Puppet Test':
  ensure => 'absent',
  data   => {
    name => 'PUPPET_TEST_LIG'
  }
}
