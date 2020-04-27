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
# This example works for either resourcename or name except for enclosureUri and subnetUri
# This example works if you already have an OsDeploymentPlan.

# Creates an Ethernet Network with Subnet Settings.
# If you already has Ethernet Network ready with Subnet Settings, you can skip this step.
oneview_ethernet_network{'deploy':
  ensure => 'present',
  data   => {
    name      => 'deploy',
    vlanId    => '101',
    purpose   => 'General',
    smartLink => true
  }
}

$interconnect_type_1 = 'Virtual Connect SE 40Gb F8 Module for Synergy'
$interconnect_type_2 = 'Synergy 20Gb Interconnect Link Module'

# Creates Logical Interconnect Group with osDeploymentSettings,upLinkSets
oneview_logical_interconnect_group{'Test Puppet LIG':
  ensure => 'present',
  data   => {
    name               => 'Test Puppet LIG',
    redundancyType     => 'HighlyAvailable',
    interconnectBaySet => 3,
    enclosureType      => 'SY12000',
    enclosureIndexes   => [1, 2, 3],
    uplinkSets         =>
    [
      {
        name                => 'deploy',
        ethernetNetworkType => 'ImageStreamer',
        networkType         => 'Ethernet',
        lacpTimer           => 'Short',
        mode                => 'Auto',
        uplink_ports        => [{ bay             => 3,
                                  port            => 87,
                                  enclosure_index => 1 },
                                { bay             => 6,
                                  port            => 87,
                                  enclosure_index => 2 },
                                { bay             => 3,
                                  port            => 82,
                                  enclosure_index => 1 },
                                { bay             => 6,
                                  port            => 82,
                                  enclosure_index => 2 }],
        networkUris         => [ 'deploy' ]
      },
      {
        name                => 'management',
        ethernetNetworkType => 'Untagged',
        networkType         => 'Ethernet',
        lacpTimer           => 'Short',
        mode                => 'Auto',
        uplink_ports        => [{ bay             => 3,
                                  port            => 62,
                                  enclosure_index => 1 },
                                { bay             => 6,
                                  port            => 62,
                                  enclosure_index => 2 }],
        networkUris         => [ 'mgmt' ]
      },
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

# Creates EnclosureGroup with osDeploymentSettings using Logical Interconnect Group created above
oneview_enclosure_group{'Test Puppet Enclosure Group':
  ensure  => 'present',
  require => Oneview_logical_interconnect_group['Test Puppet LIG'],
  data    => {
    name                        => 'Test Puppet Enclosure Group',
    stackingMode                => 'Enclosure',
    interconnectBayMappingCount => '8',
    enclosureCount              => '3',
    osDeploymentSettings        => {
      manageOSDeployment     => true,
      deploymentModeSettings => {
        deploymentMode       => 'Internal'
      }
    },
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

# Power off the Server Hardware to apply ServerProfile
oneview_server_hardware{'Test Server Hardware Power Off':
    ensure => 'set_power_state',
    data   => {
      hostname    => '0000A66101, bay 5',
      power_state => 'off',
    },
}

# Creates ServerProfileTemplate with osDeploymentPlan, Hardware and boot settings.
# You must have managementNetwork ready with subnet and deploymentNetwork prior execution of this step.
oneview_server_profile_template{'Test Puppet SPT':
  ensure  => 'present',
  require => Oneview_enclosure_group['Test Puppet Enclosure Group'],
  data    => {
    name                  => 'Test Puppet SPT',
    enclosureGroupUri     => Oneview_enclosure_group['Test Puppet Enclosure Group']['data']['name'],
    serverHardwareTypeUri => 'SY 480 Gen9 1',
    osDeploymentSettings  => {
      osDeploymentPlanUri => 'Basic Deployment Plan'
    },
    connectionSettings    =>
    {
      manageConnections => true,
      connections       =>
      [
      {
          id            => 1,
          networkUri    => 'mgmt',
          name          => 'c1',
          functionType  => 'Ethernet',
          portId        => 'Mezz 3:1-c',
          requestedMbps => '2000',
          requestedVFs  => 'Auto',
          boot          => {
            priority    => 'NotBootable'
          }
      },
      {
          id            => 2,
          networkUri    => 'mgmt1',
          name          => 'c2',
          functionType  => 'Ethernet',
          portId        => 'Mezz 3:1-d',
          requestedMbps => '2000',
          requestedVFs  => 'Auto',
          boot          => {
            priority    => 'NotBootable'
          }
      },
      {
          id            => 3,
          networkUri    => 'mgmt2',
          name          => 'c3',
          functionType  => 'Ethernet',
          portId        => 'Mezz 3:1-e',
          requestedMbps => '2000',
          requestedVFs  => 'Auto',
          boot          => {
            priority    => 'NotBootable'
          }
      },
      {
          id            => 4,
          networkUri    => 'mgmt3',
          name          => 'c4',
          functionType  => 'Ethernet',
          portId        => 'Mezz 3:1-f',
          requestedMbps => '2000',
          requestedVFs  => 'Auto',
          boot          => {
            priority    => 'NotBootable'
          }
      },
      {
          id            => 5,
          networkUri    => 'mgmt4',
          name          => 'c5',
          functionType  => 'Ethernet',
          portId        => 'Mezz 3:1-g',
          requestedMbps => '2000',
          requestedVFs  => 'Auto',
          boot          => {
            priority    => 'NotBootable'
          }
      },
      {
          id            => 6,
          networkUri    => 'mgmt5',
          name          => 'c6',
          functionType  => 'Ethernet',
          portId        => 'Mezz 3:1-h',
          requestedMbps => '2000',
          requestedVFs  => 'Auto',
          boot          => {
            priority    => 'NotBootable'
          }
      },
      {
          id            => 7,
          networkUri    => 'deploy',
          name          => 'DeploymentNetworkA',
          functionType  => 'Ethernet',
          portId        => 'Mezz 3:1-a',
          requestedMbps => '2000',
          requestedVFs  => 'Auto',
          boot          => {
            priority    => 'Primary'
          }
      },
      {
          id            => 8,
          networkUri    => 'deploy',
          name          => 'DeploymentNetworkB',
          functionType  => 'Ethernet',
          portId        => 'Mezz 3:2-a',
          requestedMbps => '2000',
          requestedVFs  => 'Auto',
          boot          => {
            priority    => 'Secondary',
          }
      }
      ]
    },
    boot                  =>
    {
      manageBoot => true,
      order      =>
      [
      'HardDisk'
      ]
    },
    bootMode              =>
    {
      manageMode    => true,
      mode          => 'UEFIOptimized',
      pxeBootPolicy => 'Auto'
    },
    bios                  =>
    {
      manageBios         => true
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
