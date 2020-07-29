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
# This example requires the following resources before executing:
# Ethernet network - iSCSI, Management


# Vars
$server_profile_name = 'Server profile with OS Deployment Plan - PUPPET DEMO'
$server_hardware_name = 'F2-CN7515049D, bay 8'
$server_hardware_type = 'SY 480 Gen9 1'
$network_1 = '/rest/ethernet-networks/1aaec4f8-c1c3-4178-a23c-fc4c118frees'
$network_2 = '/rest/ethernet-networks/1aaec4f8-c1c3-4178-a23c-fc4c118de4db'
$deployment_plan_name = 'Bootstrap_DCOS'

# Powering off the server in order to apply the Server Profile
# WARNING: This is a non-idempotent operation
oneview_server_hardware{'Server Hardware Power Off':
    ensure => 'set_power_state',
    data   => {
      hostname    => $server_hardware_name,
      power_state => 'off',
    },
}

# Create and apply a Server Profile, using Image Streamer to deploy the OS
oneview_server_profile{'Server Profile Creation':
  ensure => 'present',
  data   =>
  {
    name                  => $server_profile_name,
    serverHardwareUri     => $server_hardware_name,
    serverHardwareTypeUri => $server_hardware_type,
    osDeploymentSettings  => {
      osDeploymentPlanUri => $deployment_plan_name
    },
    boot                  => {
      manageBoot => true,
      order      => [ 'HardDisk' ]
    },
    bootMode              => {
      manageMode    => true,
      pxeBootPolicy => 'Auto',
      mode          => 'UEFIOptimized',
    },
    connectionSettings    => {
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
      {
        id            => 2,
        name          => 'connection2',
        functionType  => 'Ethernet',
        networkUri    => $network_2,
        requestedMbps => 2500,
        requestedVFs  => 'Auto',
        boot          => {
          priority            => 'Primary',
          ethernetBootType    => 'iSCSI',
          iscsi               => {
            initiatorNameSource => 'ProfileInitiatorName'
          }
        }
      },
      {
        id            => 3,
        name          => 'connection3',
        functionType  => 'Ethernet',
        networkUri    => $network_2,
        requestedMbps => 2500,
        requestedVFs  => 'Auto',
        boot          => {
          priority            => 'Secondary',
          ethernetBootType    => 'iSCSI',
          iscsi               => {
            initiatorNameSource => 'ProfileInitiatorName'
          }
        }
      }
    ]
  }
}

# Power on the Server Hardware after the Server Profile has been applied
# WARNING: This is a non-idempotent operation
oneview_server_hardware{'Server Hardware Power On':
    ensure => 'set_power_state',
    data   => {
      hostname    => $server_hardware_name,
      power_state => 'on',
    },
}
