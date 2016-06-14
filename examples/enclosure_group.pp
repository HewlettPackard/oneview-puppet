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

oneview_enclosure_group{'Enclosure Group Create':
    ensure  => 'present',
    data    => {
      name => 'Enclosure Group',
      stackingMode => 'Enclosure',
      interconnectBayMappingCount => "8",
      type => 'EnclosureGroupV200',
      interconnectBayMappings =>
      [
        {
          interconnectBay => "1",
          logicalInterconnectGroupUri => 'nil'
        },
        {
          interconnectBay => "2",
          logicalInterconnectGroupUri => 'nil'
        },
        {
          interconnectBay => "3",
          logicalInterconnectGroupUri => 'nil'
        },
        {
          interconnectBay => "4",
          logicalInterconnectGroupUri => 'nil'
        },
        {
          interconnectBay => "5",
          logicalInterconnectGroupUri => 'nil'
        },
        {
          interconnectBay => "6",
          logicalInterconnectGroupUri => 'nil'
        },
        {
          interconnectBay => "7",
          logicalInterconnectGroupUri => 'nil'
        },
        {
          interconnectBay => "8",
          logicalInterconnectGroupUri => 'nil'
        }
      ]
    }
}

oneview_enclosure_group{'Enclosure Group Found':
    require => Oneview_enclosure_group['Enclosure Group Create'],
    ensure  => 'found',
    data    => {
      name  => 'Enclosure Group',
    }
}

oneview_enclosure_group{'Enclosure Group Update':
    require => Oneview_enclosure_group['Enclosure Group Found'],
    ensure  => 'present',
    data    => {
      name  => 'Enclosure Group',
      new_name => 'New Enclosure Group Name'
    }
}

oneview_enclosure_group{'Enclosure Group Delete':
    require => Oneview_enclosure_group['Enclosure Group Update'],
    ensure  => 'absent',
    data    => {
      name => 'New Enclosure Group Name'
    }
}
