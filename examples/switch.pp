################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
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
    ensure  => 'get_type',
    require => Oneview_switch['switch_1'],
    # A data hash is optional for the get_type ensurable, and serves as a filter for the types
    data    => {
      name                => 'Cisco Nexus 50xx',
    }
}

# Get statistics for a switch, for the specified port or port/subport duo
oneview_switch{'switch_3':
    ensure  => 'get_statistics',
    require => Oneview_switch['switch_2'],
    # Here a 'port_name' or 'port_name'+'subport_number' can be specified in the data hash for filtering
    # or left blank
    data    => {
      # name is the name of the switch which will be queried for statistics and is required
      name                      => '172.18.20.1',
      # port_name                => '1.4',
    }
}

# Get environmental configuration for a switch
oneview_switch{'switch_4':
    ensure  => 'get_environmental_configuration',
    require => Oneview_switch['switch_3'],
    data    => {
      # name is the name of the switch which will be queried for its environmental configuration and is required
      name                      => '172.18.20.1',
    }
}

oneview_switch{'switch_5':
    ensure  => 'absent',
    require => Oneview_switch['switch_4'],
    data    => {
      name => '172.18.20.1'
    }
}
