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
    name           => 'Test Puppet Network',
    vlanId         => '1045',
    purpose        => 'General',
    smartLink      => true,
    privateNetwork => false,
  }
}

$interconnect_type_1 = 'Virtual Connect SE 40Gb F8 Module for Synergy'
$interconnect_type_2 = 'Synergy 20Gb Interconnect Link Module'
$network_names = [ 'Test Puppet Network' ]

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

oneview_sas_logical_interconnect_group{'Test Puppet SAS LIG':
  ensure  => 'present',
  require => Oneview_logical_interconnect_group['Test Puppet LIG'],
  data    => {
    name          => 'Test Puppet SAS LIG',
    interconnects =>
    [
      {
        bay  => 1,
        type => 'Synergy 12Gb SAS Connection Module'
      },
      {
        bay  => 4,
        type => 'Synergy 12Gb SAS Connection Module'
      }
    ]
  }
}

oneview_enclosure_group{'Test Enclosure Group':
  ensure  => 'present',
  require => Oneview_sas_logical_interconnect_group['Test Puppet SAS LIG'],
  data    => {
    name                        => 'Test Enclosure Group',
    stackingMode                => 'Enclosure',
    interconnectBayMappingCount => '8',
    enclosureCount              => '3',
    interconnectBayMappings     =>
    [
      {
        interconnectBay             => '1',
        logicalInterconnectGroupUri => Oneview_sas_logical_interconnect_group['Test Puppet SAS LIG']['data']['name'],
        enclosureIndex              => '1'
      },
      {
        interconnectBay             => '4',
        logicalInterconnectGroupUri => Oneview_sas_logical_interconnect_group['Test Puppet SAS LIG']['data']['name'],
        enclosureIndex              => '1'
      },
      {
        interconnectBay             => '1',
        logicalInterconnectGroupUri => Oneview_sas_logical_interconnect_group['Test Puppet SAS LIG']['data']['name'],
        enclosureIndex              => '2'
      },
      {
        interconnectBay             => '4',
        logicalInterconnectGroupUri => Oneview_sas_logical_interconnect_group['Test Puppet SAS LIG']['data']['name'],
        enclosureIndex              => '2'
      },
      {
        interconnectBay             => '1',
        logicalInterconnectGroupUri => Oneview_sas_logical_interconnect_group['Test Puppet SAS LIG']['data']['name'],
        enclosureIndex              => '3'
      },
      {
        interconnectBay             => '4',
        logicalInterconnectGroupUri => Oneview_sas_logical_interconnect_group['Test Puppet SAS LIG']['data']['name'],
        enclosureIndex              => '3'
      },
      {
        interconnectBay             => '3',
        logicalInterconnectGroupUri => Oneview_logical_interconnect_group['Test Puppet LIG']['data']['name']
      },
      {
        interconnectBay             => '6',
        logicalInterconnectGroupUri => Oneview_logical_interconnect_group['Test Puppet LIG']['data']['name']
      },
    ]
  }
}

oneview_logical_enclosure{'Test LE':
  ensure  => 'present',
  require => Oneview_enclosure_group['Test Enclosure Group'],
  data    => {
    name                 => 'Test LE',
    enclosureUris        => ['/rest/enclosures/0000000000A66101', '/rest/enclosures/0000000000A66102', '/rest/enclosures/0000000000A66103'],
    enclosureGroupUri    => Oneview_enclosure_group['Test Enclosure Group']['data']['name'],
    firmwareBaselineUri  => 'null',
    forceInstallFirmware => 'false',
  }
}

oneview_server_profile_template{'Test SPT':
  ensure  => 'present',
  require => Oneview_logical_enclosure['Test LE'],
  data    => {
    name                  => 'Test SPT',
    enclosureGroupUri     => Oneview_enclosure_group['Test Enclosure Group']['data']['name'],
    serverHardwareTypeUri => 'SY 480 Gen9 1',
    connectionSettings    =>
    {
      manageConnections => true,
      connections       =>
      [
      {
          id            => 1,
          networkUri    => Oneview_ethernet_network['Test Puppet Network']['data']['name'],
          functionType  => 'Ethernet',
          portId        => 'Mezz 3:1-a',
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

oneview_server_profile_template{'Test Server Profile Create from Profile Template':
  ensure  => 'set_new_profile',
  require => Oneview_server_profile_template['Test SPT'],
  data    => {
    name => 'Test SPT'
  }
}
