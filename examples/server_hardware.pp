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

# NOTE: Other than the 'found' method, all methods require a name/id for a server hardware to be specified

# NOTE: Updating the name of the resource is not supported for this resource
oneview_server_hardware{'server_hardware_1':
    ensure => 'present',
    data   => {
      hostname        => '172.18.6.14',
      username        => 'dcs',
      password        => 'dcs',
      licensingIntent => 'OneView'
    },
}

oneview_server_hardware{'server_hardware_2':
    ensure => 'found',
}

oneview_server_hardware{'server_hardware_3':
    ensure => 'present',
    data   => {
      hostname => '172.18.6.14',
      op       => 'add',
      path     => '/scopeUris/-',
      value    => '/rest/scopes/eec90be8-e810-4aef-b976-57c2c2cce030'
    },
}

oneview_server_hardware{'server_hardware_8':
    ensure => 'add_multiple_servers',
    data   => {
      hostname         => '172.18.6.13',
      username         => 'dcs',
      password         => 'dcs',
      licensingIntent  => 'OneView',
      mpHostsAndRanges => ['172.18.6.13-172.18.6.14']
    },
}

# NOTE: This is a function specific for GEN9 Servers
# oneview_server_hardware{'server_hardware_3':
#     ensure => 'get_bios',
#     data   => {
#       hostname        => '172.18.6.14',
#     },
# }

oneview_server_hardware{'server_hardware_4':
    ensure => 'get_ilo_sso_url',
    data   => {
      hostname        => '172.18.6.14',
    },
}

oneview_server_hardware{'server_hardware_5':
    ensure => 'get_java_remote_sso_url',
    data   => {
      hostname        => '172.18.6.14',
    },
}

oneview_server_hardware{'server_hardware_6':
    ensure => 'get_remote_console_url',
    data   => {
      hostname        => '172.18.6.14',
    },
}

oneview_server_hardware{'server_hardware_7':
    ensure => 'get_environmental_configuration',
    data   => {
      hostname        => '172.18.6.14',
    },
}

oneview_server_hardware{'server_hardware_52':
    ensure => 'get_firmware_inventory',
    data   => {
      hostname        => '172.18.6.14',
    },
}

# NOTE: This resource available only with API500 and above
oneview_server_hardware{'server_hardware_51':
    ensure => 'get_physical_server_hardware',
    data   => {
      hostname        => '172.18.6.14',
    },
}

# NOTE: This resource accepts an optional field 'queryParameters' to filter out information
oneview_server_hardware{'server_hardware_8':
    ensure => 'get_utilization',
    data   => {
      hostname        => '172.18.6.14',
      queryParameters => {
        fields => ['AmbientTemperature']
      }
    },
}

oneview_server_hardware{'server_hardware_9':
    ensure => 'update_ilo_firmware',
    data   => {
      hostname        => '172.18.6.14',
    },
}

oneview_server_hardware{'server_hardware_10':
    ensure => 'set_power_state',
    data   => {
      hostname    => '172.18.6.14',
      power_state => 'on',
    },
}

# NOTE: This resource requires a state of 'RefreshPending'
# NOTE: This resource accepts an optional field 'options' for refreshing the server hardware
oneview_server_hardware{'server_hardware_11':
    ensure => 'set_refresh_state',
    data   => {
      hostname => '172.18.6.14',
      state    => 'RefreshPending'
    },
}

oneview_server_hardware{'server_hardware_12':
    ensure => 'absent',
    data   => {
      hostname        => '172.18.6.14',
      username        => 'dcs',
      password        => 'dcs',
      licensingIntent => 'OneView'
    },
}


