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

oneview_fc_network{'fc1':
    ensure => 'present',
    data   => {
      name                    => 'OneViewSDK Test FC Network',
      connectionTemplateUri   => nil,
      autoLoginRedistribution => true,
      fabricType              => 'FabricAttach',
    }
}

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
                                  type            => 'Virtual Connect SE 40Gb F8 Module for Synergy',
                                  enclosure_index => 1 },
                                { bay             => 6,
                                  port            => 'Q1',
                                  type            => 'Virtual Connect SE 40Gb F8 Module for Synergy',
                                  enclosure_index => 2 }
        ],
        networkUris         => [ 'Test Puppet Network' ]
      }
    ],
    interconnects      =>
    [
      {
        bay             => 3,
        type            => 'Virtual Connect SE 40Gb F8 Module for Synergy',
        enclosure_index => 1
      },
      {
        bay             => 6,
        type            => 'Virtual Connect SE 40Gb F8 Module for Synergy',
        enclosure_index => 2
      },
      {
        bay             => 3,
        type            => 'Virtual Connect SE 40Gb F8 Module for Synergy',
        enclosure_index => 2
      },
      {
        bay             => 6,
        type            => 'Virtual Connect SE 40Gb F8 Module for Synergy',
        enclosure_index => 1
      },
      {
        bay             => 3,
        type            => 'Virtual Connect SE 40Gb F8 Module for Synergy',
        enclosure_index => 3
      },
      {
        bay             => 6,
        type            => 'Virtual Connect SE 40Gb F8 Module for Synergy',
        enclosure_index => 3
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

oneview_storage_system{'storage_system_1':
    ensure => 'present',
    data   => {
      family      => 'StoreServ',
      hostname    => '172.18.11.11',
      credentials => {
        username => 'dcs',
        password => 'dcs',
      },
      description => 'Standard Description for Sample Purposes'
    }
}

oneview_storage_pool{'Storage Pool':
  ensure  => 'present',
  require => Oneview_storage_system['storage_system_1'],
  data    =>
  {
    poolName         => 'CPG-SSD-AO',
    storageSystemUri => 'ThreePAR7200-8392'
  }
}

oneview_volume{'Volume':
  ensure  => 'present',
  require => Oneview_storage_pool['Storage Pool'],
  data    =>
  {
    name                   => 'Puppet Volume',
    description            => 'Test volume with common creation: Storage System + Storage Pool',
    snapshotPoolUri        => 'CPG-SSD-AO',
    provisioningParameters =>
    {
      provisionType     => 'Full',
      shareable         => true,
      requestedCapacity => 1024 * 1024 * 1024,
      storagePoolUri    => 'CPG-SSD-AO',
    }
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
    }
  }
}

# Powering off the server in order to apply the Server Profile
oneview_server_hardware{'Server Hardware':
    ensure => 'set_power_state',
    data   => {
      hostname    => 'F2-CN7515049D, bay 8',
      power_state => 'off',
    },
}

oneview_server_hardware_type{'Server Hardware Type':
    ensure  => 'present',
    require => Oneview_server_hardware['Server Hardware'],
    data    =>
    {
      name => 'SY 480 Gen9 1'
    }
}

# Create and apply a Server Profile and assign to hardware function for adding connection to profile
oneview_server_profile{'Server Profile update from Template':
  ensure  => 'update_from_template',
  require => Oneview_server_profile_template['Test SPT']
  data    =>
  {
    name                  => 'Server profile with Hardware - PUPPET DEMO',
    serverHardwareUri     => 'F2-CN7515049D, bay 8',
    serverHardwareTypeUri => 'SY 480 Gen9 1',
    boot                  => {
      manageBoot => true,
      order      => [ 'HardDisk' ]
    },
    bootMode              => {
      manageMode    => true,
      pxeBootPolicy => 'Auto',
      mode          => 'UEFIOptimized',
    },
    connections           => [
      {
        id            => 1,
        name          => 'connection1',
        functionType  => 'Ethernet',
        networkUri    => $network_1,
        requestedMbps => 2500,
        requestedVFs  => 'Auto',
        boot          => {
          priority            => 'NotBootable',
        }
      },
    ]
  }
}

# Power on the Server Hardware after the Server Profile has been applied
oneview_server_hardware{'Server Hardware Power On':
    ensure => 'set_power_state',
    data   => {
      hostname    => $server_hardware_name,
      power_state => 'on',
    },
}