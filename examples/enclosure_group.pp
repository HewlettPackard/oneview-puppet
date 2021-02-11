################################################################################
# (C) Copyright 2019-2020 Hewlett Packard Enterprise Development LP
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
#
# NOTE: Create a logical interconnect group for single enclosure as a pre-requisite

# Variable declaration
$eg_name = 'Enclosure Group'

oneview_enclosure_group{'Enclosure Group Get All':
    ensure  => 'found'
}

# 'interconnectBayMappings' does not need to be specified if the values are nil
oneview_enclosure_group{'Enclosure Group Create':
    ensure => 'present',
    data   => {
      name                        => $eg_name,
      stackingMode                => 'Enclosure',
      enclosureCount              => '1',
      interconnectBayMappingCount => '2',
      interconnectBayMappings     => [
        {
          interconnectBay             => '3',
          logicalInterconnectGroupUri => 'LIG'
        },
        {
          interconnectBay             => '6',
          logicalInterconnectGroupUri => 'LIG'
        }
      ]
    }
}

oneview_enclosure_group{'Enclosure Group Found':
    ensure  => 'found',
    require => Oneview_enclosure_group['Enclosure Group Create'],
    data    => {
      name  => $eg_name,
    }
}

oneview_enclosure_group{'Enclosure Group Update':
    ensure  => 'present',
    require => Oneview_enclosure_group['Enclosure Group Found'],
    data    => {
      name     => $eg_name,
      new_name => 'New Enclosure Group Name'
    }
}

oneview_enclosure_group{'Enclosure Group Update_2':
    ensure  => 'present',
    require => Oneview_enclosure_group['Enclosure Group Found'],
    data    => {
      name     => 'New Enclosure Group Name',
      new_name => $eg_name
    }
}

# The method #set_script is available for C7000 variant only.
oneview_enclosure_group{'Enclosure Group Set Script':
    ensure  => 'set_script',
    require => Oneview_enclosure_group['Enclosure Group Update'],
    data    => {
      name   => $eg_name,
      script => 'This is a script example'
    }
}

# The method #get_script is available for C7000 variant only.
oneview_enclosure_group{'Enclosure Group Get Script':
    ensure  => 'get_script',
    require => Oneview_enclosure_group['Enclosure Group Set Script'],
    data    => {
      name => $eg_name
    }
}

oneview_enclosure_group{'Enclosure Group Delete':
    ensure => 'absent',
#    require => Oneview_enclosure_group['Enclosure Group Get Script'],
    data   => {
      name => $eg_name
    }
}
