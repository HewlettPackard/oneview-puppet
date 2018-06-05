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

oneview_switch{'switch_1':
    ensure => 'found',
    # A data hash is optional for the found ensurable, and serves as a filter for the switches
    # data   => {
    #   name                => 'Puppet Switch',
    # }
}

oneview_switch{'switch_2':
    ensure => 'get_type',
    # A data hash is optional for the get_type ensurable, and serves as a filter for the types
    data   => {
      name                => 'Cisco Nexus 56xx',
    }
}

# Get statistics for a switch, for the specified port or port/subport duo
  # NOTE: Here a 'port_name' or 'port_name'+'subport_number' can be specified in the data hash for filtering
  # or left blank
  # NOTE 2: A unique identifier such as 'name' for the switch which will be queried for statistics is required
oneview_switch{'switch_3':
    ensure  => 'get_statistics',
    require => Oneview_switch['switch_2'],
    data    => {
      name                      => '172.18.16.92',
      # port_name                => '1.4',
    }
}

# Get environmental configuration for a switch
# NOTE 1: A unique identifier such as 'name' for the switch which will be queried for statistics is required
oneview_switch{'switch_4':
    ensure  => 'get_environmental_configuration',
    require => Oneview_switch['switch_3'],
    data    => {
      name                      => '172.18.16.92',
    }
}

# This ensure method requires a unique identifier for the switch and the 'scope_uris' field, containing an array of the scope uris
# This method is depricated from V500 and above
# oneview_switch{'switch_5':
#     ensure  => 'set_scope_uris',
#     require => Oneview_switch['switch_3'],
#     data    => {
#       name       => '172.18.16.92',
#       scope_uris => ['/rest/scopes/fee00629-9931-426d-8771-a597917eb9d2','/rest/scopes/4cd2c577-6a6c-4bbc-a3fc-5e4ab3326e21']
#     }
# }

oneview_switch{'switch_6':
    ensure  => 'absent',
    require => Oneview_switch['switch_4'],
    data    => {
      name => '172.18.16.92'
    }
}
