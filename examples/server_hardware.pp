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

# NOTE: Other than the 'found' method, all methods require a name/id for a server hardware to be specified

# Variable declaration
$sh_name = '0000A66101, bay 3'

# NOTE: Updating the name of the resource is not supported for this resource
# This example works only for C7000
oneview_server_hardware{'server_hardware_1':
    ensure => 'present',
    data   => {
      hostname        => '<hostname>',
      username        => '<username>',
      password        => '<password>',
      licensingIntent => 'OneView'
    },
}

oneview_server_hardware{'server_hardware_2':
    ensure => 'found',
}

# This example works only for C7000
oneview_server_hardware{'server_hardware_3':
    ensure => 'present',
    data   => {
      hostname => '<hostname>',
      op       => 'add',
      path     => '/scopeUris/-',
      value    => '/rest/scopes/5438f376-b61f-45b1-8c11-052a48a474ad'
    },
}

# This works only for C7000
oneview_server_hardware{'server_hardware_4':
    ensure => 'add_multiple_servers',
    data   => {
      hostname         => '<hostname>',
      username         => '<username>',
      password         => '<password>',
      licensingIntent  => 'OneView',
      mpHostsAndRanges => ['<start>-<end>']
    },
}

# NOTE: This is a function specific for GEN9 Servers
# hostname should be provided for C7000
oneview_server_hardware{'server_hardware_30':
    ensure => 'get_bios',
    data   => {
      name    => $sh_name,
#      hostname        => '<hostname>',
    },
}

oneview_server_hardware{'server_hardware_5':
    ensure => 'get_ilo_sso_url',
    data   => {
      name    => $sh_name
    },
}

oneview_server_hardware{'server_hardware_6':
    ensure => 'get_java_remote_sso_url',
    data   => {
      name    => $sh_name
    },
}

oneview_server_hardware{'server_hardware_7':
    ensure => 'get_remote_console_url',
    data   => {
      name    => $sh_name
    },
}

oneview_server_hardware{'server_hardware_8':
    ensure => 'get_environmental_configuration',
    data   => {
      name    => $sh_name
    },
}

oneview_server_hardware{'server_hardware_9':
    ensure => 'get_firmware_inventory',
    data   => {
      name    => $sh_name
    },
}

# NOTE: This resource available only with API500 and above
oneview_server_hardware{'server_hardware_10':
    ensure => 'get_physical_server_hardware',
    data   => {
      name    => $sh_name
    },
}

# NOTE: This resource accepts an optional field 'queryParameters' to filter out information
oneview_server_hardware{'server_hardware_11':
    ensure => 'get_utilization',
    data   => {
      name            => $sh_name,
      queryParameters => {
        fields => ['AmbientTemperature']
      }
    },
}

oneview_server_hardware{'server_hardware_12':
    ensure => 'update_ilo_firmware',
    data   => {
      name    => $sh_name
    },
}

oneview_server_hardware{'server_hardware_13':
    ensure => 'set_power_state',
    data   => {
      name        => $sh_name,
      power_state => 'on',
    },
}

oneview_server_hardware{'server_hardware_14':
    ensure => 'get_local_storage',
    data   => {
      name    => $sh_name
    },
}

# This example works only for server hardware having local_storageV2 schema
oneview_server_hardware{'server_hardware_15':
    ensure => 'get_local_storagev2',
    data   => {
      name    => $sh_name
    },
}

# NOTE: This resource requires a state of 'RefreshPending'
# NOTE: This resource accepts an optional field 'options' for refreshing the server hardware
oneview_server_hardware{'server_hardware_16':
    ensure => 'set_refresh_state',
    data   => {
      name  => $sh_name,
      state => 'RefreshPending'
    },
}

# Delete operation works only for C7000
oneview_server_hardware{'server_hardware_17':
    ensure => 'absent',
    data   => {
      hostname        => '<hostname>',
      username        => '<username>',
      password        => '<password>',
      licensingIntent => 'OneView'
    },
}
