################################################################################
# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
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

# This example works for api_variant "Synergy"
# Create FC Network
oneview_fc_network{'Test Puppet FC Network Create1':
  ensure => 'present',
  data   => {
    name                    => 'Test Puppet FC Network Create1',
    connectionTemplateUri   => nil,
    autoLoginRedistribution => true,
    fabricType              => 'FabricAttach'
    }
}

# Create Ethernet Network
oneview_ethernet_network{'Test Puppet Network':
  ensure => 'present',
  data   => {
    name           => 'Test Puppet Network',
    vlanId         => '1045',
    purpose        => 'General',
    smartLink      => true,
    privateNetwork => false
  }
}

# Create another Ethernet Network
oneview_ethernet_network{'Test Puppet Network Create1':
  ensure => 'present',
  data   => {
    name           => 'Test Puppet Network Create1',
    vlanId         => '1000',
    purpose        => 'General',
    smartLink      => true,
    privateNetwork => false
  }
}

# Creates Storage System in OneView
# If you already have Storage System, then you can skip this step
oneview_storage_system{'Test Puppet Storage System':
    ensure => 'present',
    data   => {
      family   => 'StoreServ',
      hostname => '172.18.11.11',
      username => 'dcs',
      password => 'dcs'
    }
}

# Creates Storage Pool in OneView
# If you already have Storage Pool, then you can skip this step
oneview_storage_pool{'Test Puppet Storage Pool':
  ensure  => 'present',
  require => Oneview_storage_system['Test Puppet Storage System'],
  data    =>
  {
    poolName         => 'CPG-SSD-AO',
    storageSystemUri => 'ThreePAR-1'
  }
}

$interconnect_type_1 = 'Virtual Connect SE 40Gb F8 Module for Synergy'
$interconnect_type_2 = 'Synergy 20Gb Interconnect Link Module'
$network_names = [ 'Test Puppet Network', 'Test Puppet Network Create1' ]

# Creates Logical Interconnect Group with uplinkSets, Redundancy, Boot settings in Synergy
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

# Creates EnclosureGroup using Logical Interconnect Group created above
oneview_enclosure_group{'Test Puppet Enclosure Group':
  ensure  => 'present',
  require => Oneview_logical_interconnect_group['Test Puppet LIG'],
  data    => {
    name                        => 'Test Puppet Enclosure Group',
    stackingMode                => 'Enclosure',
    interconnectBayMappingCount => '8',
    enclosureCount              => '3',
    interconnectBayMappings     =>
    [
      {
        interconnectBay             => '3',
        logicalInterconnectGroupUri => Oneview_logical_interconnect_group['Test Puppet LIG']['data']['name'],
        enclosureIndex              => '1'
      },
      {
        interconnectBay             => '6',
        logicalInterconnectGroupUri => Oneview_logical_interconnect_group['Test Puppet LIG']['data']['name'],
        enclosureIndex              => '1'
      },
      {
        interconnectBay             => '3',
        logicalInterconnectGroupUri => Oneview_logical_interconnect_group['Test Puppet LIG']['data']['name'],
        enclosureIndex              => '2'
      },
      {
        interconnectBay             => '6',
        logicalInterconnectGroupUri => Oneview_logical_interconnect_group['Test Puppet LIG']['data']['name'],
        enclosureIndex              => '2'
      },
      {
        interconnectBay             => '3',
        logicalInterconnectGroupUri => Oneview_logical_interconnect_group['Test Puppet LIG']['data']['name'],
        enclosureIndex              => '3'
      },
      {
        interconnectBay             => '6',
        logicalInterconnectGroupUri => Oneview_logical_interconnect_group['Test Puppet LIG']['data']['name'],
        enclosureIndex              => '3'
      }
    ]
  }
}

# Creates Logical Enclosure
oneview_logical_enclosure{'Test Puppet LE':
  ensure  => 'present',
  require => Oneview_enclosure_group['Test Puppet Enclosure Group'],
  data    => {
    name                 => 'Test Puppet LE',
    enclosureUris        => ['/rest/enclosures/0000000000A66101', '/rest/enclosures/0000000000A66102', '/rest/enclosures/0000000000A66103'],
    enclosureGroupUri    => Oneview_enclosure_group['Test Puppet Enclosure Group']['data']['name'],
    firmwareBaselineUri  => 'null',
    forceInstallFirmware => 'false',
  }
}

# Power off the Server Hardware after the Server Profile has been applied
oneview_server_hardware{'Test Server Hardware Power Off':
    ensure => 'set_power_state',
    data   => {
      hostname    => '0000A66101, bay 5',
      power_state => 'off',
    },
}

# Creates ServerProfileTemplate with Storage, Hardware and boot settings
oneview_server_profile_template{'Test Puppet SPT':
  ensure  => 'present',
  require => Oneview_enclosure_group['Test Puppet Enclosure Group'],
  data    => {
    name                  => 'Test Puppet SPT',
    enclosureGroupUri     => Oneview_enclosure_group['Test Puppet Enclosure Group']['data']['name'],
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
      },
      {
          id            => 2,
          networkUri    => Oneview_ethernet_network['Test Puppet Network Create1']['data']['name'],
          functionType  => 'Ethernet',
          portId        => 'Mezz 3:1-b',
          requestedMbps => '2000'
      }
      ]
    },
    boot                  =>
    {
      manageBoot => true,
      order      =>
      [
      'CD',
      'USB',
      'HardDisk',
      'PXE'
      ]
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
    sanStorage            =>
    {
      manageSanStorage  => true,
      hostOSType        => 'VMware (ESXi)',
      volumeAttachments =>
      [
        {
          id           => 1,
          lun          => '',
          lunType      => 'Auto',
          storagePaths =>
          [
            {
              connectionId   => 1,
              isEnabled      => true,
              targetSelector => 'Auto'
            },
            {
              connectionId   => 2,
              isEnabled      => true,
              targetSelector => 'Auto'
            }
          ],
          volume       => {
            properties => {
                provisioningType => 'Thin',
                size             => 1073741824,
                name             => 'Test Puppet Storage Volume',
                storagePool      => '/rest/storage-pools/C6190E80-7246-42BF-92B8-AB9E00CFF1C6',
                snapshotPool     => '/rest/storage-pools/C6190E80-7246-42BF-92B8-AB9E00CFF1C6',
                isShareable      => false
            }
          },
        }
        ]
    }
  }
}

# Creates ServerProfile
oneview_server_profile{'Test Server Profile Create':
  ensure => 'present',
  data   =>
  {
    name              => 'Test Server Profile Create',
    serverHardwareUri => '/rest/server-hardware/30303437-3034-4D32-3230-313030304752',
  }
}

# Creates ServerProfile from ServerProfileTemplate created above
oneview_server_profile_template{'Test Server Profile Create from Profile Template':
  ensure  => 'set_new_profile',
  require => Oneview_server_profile_template['Test Puppet SPT'],
  data    => {
    name              => 'Test Puppet SPT',
    serverProfileName => 'Test Puppet Server Profile Create from Profile Template'
  }
}

# Power on the Server Hardware after the Server Profile has been applied
oneview_server_hardware{'Test Server Hardware Power On':
    ensure => 'set_power_state',
    data   => {
      hostname    => '0000A66101, bay 5',
      power_state => 'on',
    },
}
