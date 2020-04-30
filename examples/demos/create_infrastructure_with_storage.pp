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

# This example works for api_variant "Synergy".
# This example works with either resource uri or resource name.

# Create FC Network
# If you already have FC Network, then you can skip this step
oneview_fc_network{'Test Puppet Network':
    ensure => 'present',
    data   => {
      name                    => 'Test Puppet Network',
      connectionTemplateUri   => nil,
      autoLoginRedistribution => true,
      fabricType              => 'FabricAttach',
    }
}

# Create another FC Network
# If you already have FC Network, then you can skip this step
oneview_fc_network{'Test Puppet Network Create1':
    ensure => 'present',
    data   => {
      name                    => 'Test Puppet Network Create1',
      connectionTemplateUri   => nil,
      autoLoginRedistribution => true,
      fabricType              => 'FabricAttach',
    }
}

# Creates Storage System in OneView
# If you already have Storage System having ports configured with FC Networks,
# then you can skip this step

oneview_storage_system{'storage_system_1':
    ensure => 'present',
    data   => {
      family   => 'StoreServ',
      hostname => '172.18.11.11',
      username => 'dcs',
      password => 'dcs'
    }
}

$interconnect_type_1 = 'Virtual Connect SE 40Gb F8 Module for Synergy'
$interconnect_type_2 = 'Synergy 20Gb Interconnect Link Module'

# Creates Logical Interconnect Group with uplinkSets, Redundancy, Boot settings in Synergy
oneview_logical_interconnect_group{'Test Puppet LIG':
  ensure  => 'present',
  data    => {
    name               => 'Test Puppet LIG',
    redundancyType     => 'HighlyAvailable',
    interconnectBaySet => 3,
    enclosureType      => 'SY12000',
    enclosureIndexes   => [1, 2, 3],
    uplinkSets         =>
    [
      {
        name                => 'FC01',
        networkType         => 'FibreChannel',
        uplink_ports        => [{ bay             => 3,
                                  port            => 'Q1:1',
                                  type            => $interconnect_type_1,
                                  enclosure_index => 1 }
        ],
        networkUris         => [ 'Test Puppet Network' ]
      },
      {
        name                => 'FC02',
        networkType         => 'FibreChannel',
        uplink_ports        => [{ bay             => 3,
                                  port            => 'Q1:2',
                                  type            => $interconnect_type_1,
                                  enclosure_index => 1 }
        ],
        networkUris         => [ 'Test Puppet Network Create1' ]
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

# Powering off the Server Hardware to apply ServerProfile
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
  data    => {
    name                  => 'Test Puppet SPT',
    enclosureGroupUri     => Oneview_enclosure_group['Test Puppet Enclosure Group']['data']['name'],
    serverHardwareTypeUri => 'SY 480 Gen9 2',
    connectionSettings    =>
    {
      manageConnections => true,
      connections       =>
      [
      {
          id            => 1,
          networkUri    => 'Test Puppet Network',
          functionType  => 'FibreChannel',
          portId        => 'Mezz 3:1',
          requestedMbps => '2000'
      },
      {
          id            => 2,
          networkUri    => 'Test Puppet Network Create1',
          functionType  => 'FibreChannel',
          portId        => 'Mezz 3:2',
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
                storagePool      => '/rest/storage-pools/547F8659-BD66-4775-9943-A93C0143AC70',
                isShareable      => false
            },
            templateUri => '/rest/storage-volume-templates/3be39ea9-a481-4c9a-aed4-aa3f00c21dfb'
          },
        }
        ]
    }
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
