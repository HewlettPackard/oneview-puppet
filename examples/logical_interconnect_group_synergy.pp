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

# This sample creates a complex LIG with an Uplink and Interconnect using 2 enclosures.
# If no enclosure_index is provided for interconnects, a value of '1' is assumed.
$interconnect_type_1 = 'Virtual Connect SE 40Gb F8 Module for Synergy'
$interconnect_type_2 = 'Synergy 20Gb Interconnect Link Module'
$network_names = [ 'tunnelnet1' ]
oneview_logical_interconnect_group{'Puppet - Synergy Tunnel LIG with 2 Enclosures':
  ensure => 'present',
  data   => {
    name               => 'Puppet - Synergy Tunnel LIG with 2 Enclosures',
    redundancyType     => 'HighlyAvailable',
    interconnectBaySet => 3,
    enclosureType      => 'SY12000',
    enclosureIndexes   => [1, 2],
    uplinkSets         =>
    [
      {
        name                => 'TUNNEL_ETH_UP_01',
        ethernetNetworkType => 'Tunnel',
        networkType         => 'Ethernet',
        lacpTimer           => 'Short',
        mode                => 'Auto',
        uplink_ports        => [{ bay             => 3,
                                  port            => 'Q1',
                                  type            => $interconnect_type_1,
                                  enclosure_index => 1 },
                                { bay             => 6,
                                  port            => 'Q1',
                                  type            => $interconnect_type_1,
                                  enclosure_index => 2 }
        ],
        networkUris         => $network_names
      }
    ],
    interconnects      =>
    [
      {
        bay             => 3,
        type            => $interconnect_type_1,
        enclosure_index => 1
      },
      {
        bay             => 6,
        type            => $interconnect_type_1,
        enclosure_index => 2
      },
      {
        bay             => 3,
        type            => $interconnect_type_2,
        enclosure_index => 2
      },
      {
        bay             => 6,
        type            => $interconnect_type_2,
        enclosure_index => 1
      }
    ]
  }
}

# The value [-1] for enclosureIndexes indicates that this is a single enclosure
# logical interconnect group for Virtual Connect SE 16Gb FC Module.
# It is required for FC Logical Interconnect Groups.
oneview_logical_interconnect_group{'Puppet FC LIG Synergy':
  ensure => 'present',
  data   => {
    name               => 'Puppet FC LIG Synergy',
    redundancyType     => 'Redundant',
    enclosureIndexes   => [-1],
    interconnectBaySet => 1,
    interconnects      =>
    [
      {
        bay             => 1,
        type            => 'Virtual Connect SE 16Gb FC Module for Synergy',
        enclosure_index => -1
      },
      {
        bay             => 4,
        type            => 'Virtual Connect SE 16Gb FC Module for Synergy',
        enclosure_index => -1
      },
    ]
  }
}

oneview_logical_interconnect_group{'Logical Interconnect Group Edit':
  ensure  => 'present',
  require => Oneview_logical_interconnect_group['Puppet - Synergy Tunnel LIG with 2 Enclosures'],
  data    => {
    name     => 'Puppet - Synergy Tunnel LIG with 2 Enclosures',
    new_name => 'Edited LIG'
  }
}

oneview_logical_interconnect_group{'Logical Interconnect Group Found':
  ensure  => 'found',
  require => Oneview_logical_interconnect_group['Logical Interconnect Group Edit'],
  # data   => {
  #   name => 'Edited LIG'
  # }
}

oneview_logical_interconnect_group{'Logical Interconnect Group Get Default Settings':
  ensure  => 'get_default_settings',
  require => Oneview_logical_interconnect_group['Logical Interconnect Group Found'],
  data    => {
    name => 'Edited LIG'
  }
}

oneview_logical_interconnect_group{'Logical Interconnect Group Get Settings':
  ensure  => 'get_settings',
  require => Oneview_logical_interconnect_group['Logical Interconnect Group Get Default Settings'],
  data    => {
    name => 'Edited LIG'
  }
}

oneview_logical_interconnect_group{'Ethernet Logical Interconnect Group Destroy':
  ensure  => 'absent',
  require => Oneview_logical_interconnect_group['Logical Interconnect Group Get Settings'],
  data    => {
    name => 'Edited LIG'
  }
}


oneview_logical_interconnect_group{'FC Logical Interconnect Group Destroy':
  ensure  => 'absent',
  require => Oneview_logical_interconnect_group['Puppet FC LIG Synergy'],
  data    => {
    name => 'Puppet FC LIG Synergy'
  }
}
