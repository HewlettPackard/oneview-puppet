################################################################################
# (C) Copyright 2016-2020 Hewlett Packard Enterprise Development LP
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

oneview_ethernet_network{'Test Puppet Network':
  ensure => 'present',
  data   => {
    name           => 'Test Puppet Network #2',
    vlanId         => '1515',
    purpose        => 'General',
    smartLink      => true,
    privateNetwork => false,
  }
}

$interconnect_type_1 = 'Virtual Connect SE 40Gb F8 Module for Synergy'
$interconnect_type_2 = 'Synergy 20Gb Interconnect Link Module'
$network_names = [ 'Test Puppet Network', 'Test Puppet Network #2']
oneview_logical_interconnect_group{'Test Puppet LIG':
  ensure  => 'present',
  require => Oneview_ethernet_network['Test Puppet Network'],
  data    => {
    name               => 'Test Puppet LIG',
    redundancyType     => 'HighlyAvailable',
    interconnectBaySet => 3,
    enclosureType      => 'SY12000',
    enclosureIndexes   => [1, 2, 3],
    uplinkSets         =>
    [
      {
        name                => 'TUNNEL_ETH_UP_01',
        ethernetNetworkType => 'Tagged',
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
      },
      {
        bay             => 3,
        type            => $interconnect_type_2,
        enclosure_index => 3
      },
      {
        bay             => 6,
        type            => $interconnect_type_2,
        enclosure_index => 3
      }
    ]
  }
}

oneview_logical_interconnect{'Test Logical Interconnect Compliance':
  ensure  => 'set_compliance',
  require => Oneview_logical_interconnect_group['Test Puppet LIG'],
  data    =>
  {
    name => 'Test LE-Test Puppet LIG'
  }
}


oneview_server_profile_template{'Test Server Profile Template Update':
  ensure  => 'present',
  require => Oneview_logical_interconnect['Test Logical Interconnect Compliance'],
  data    =>
  {
    name                  => 'Test SPT',
    enclosureGroupUri     => 'Test Enclosure Group',
    serverHardwareTypeUri => 'SY 480 Gen9 1',
    connectionSettings    =>
    {
      manageConnections => true,
      connections       =>
      [
      {
          id            => 1,
          networkUri    => 'Test Puppet Network',
          functionType  => 'Ethernet',
          portId        => 'Mezz 3:1-a',
          requestedMbps => '2000'
      },
      {
          id            => 2,
          networkUri    => Oneview_ethernet_network['Test Puppet Network']['data']['name'],
          functionType  => 'Ethernet',
          portId        => 'Mezz 3:2-a',
          requestedMbps => '2000'
      }
      ]
    },
    firmware              =>
    {
      firmwareBaselineUri => 'HPE Synergy Custom SPP 201912 2019 12 19',
      manageFirmware      => true
    },
    boot                  =>
    {
      manageBoot        => true,
      order             =>
      [
      'CD',
      'USB',
      'HardDisk',
      'PXE'
      ],
      complianceControl => 'Checked'
    },
    bootMode              =>
    {
      manageMode => true,
      mode       => 'BIOS',
      secureBoot => 'Disabled'
    },
    bios                  =>
    {
      manageBios         => true
    },
    localStorage          =>
    {
      complianceControl => 'Checked',
      controllers       =>
      [
        {
          deviceSlot => 'Mezz 1',
          mode       => 'HBA',
          initialize => false
        }
      ],
      sasLogicalJBODs   =>
      [
        {
          id                => '1',
          deviceSlot        => 'Mezz 1',
          name              => 'DATA',
          numPhysicalDrives => '1',
          driveMinSizeGB    => '500',
          driveMaxSizeGB    => '500',
          driveTechnology   => 'SasHdd',
          eraseData         => false
        }
      ]
    }
  }
}

oneview_server_profile{'Server Profile update from Template':
  ensure  => 'update_from_template',
  require => Oneview_server_profile_template['Test Server Profile Template Update'],
  data    =>
  {
    name => 'Server_Profile_created_from_Test SPT'
  }
}
