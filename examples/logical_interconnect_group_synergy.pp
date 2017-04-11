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

# The Interconnects and Uplink Sets can also be declared as follows:
oneview_logical_interconnect_group{'Puppet Ethernet LIG Synergy':
  ensure => 'present',
  data   => {
    name               => 'Puppet Ethernet LIG Synergy',
    redundancyType     => 'Redundant',
    interconnectBaySet => 3,
    interconnects      =>
    [
      {
        bay  => 3,
        type => 'Virtual Connect SE 40Gb F8 Module for Synergy'
      },
      {
        bay  => 6,
        type => 'Virtual Connect SE 40Gb F8 Module for Synergy'
      },
    ]
  }
}

oneview_logical_interconnect_group{'Puppet FC LIG Synergy':
  ensure => 'present',
  data   => {
    name               => 'Puppet FC LIG Synergy',
    redundancyType     => 'Redundant',
    enclosureIndexes   => [-1],
    interconnectBaySet => 1,
    interconnects      =>
    [
      {
        bay  => 1,
        type => 'Virtual Connect SE 16Gb FC Module for Synergy'
      },
      {
        bay  => 4,
        type => 'Virtual Connect SE 16Gb FC Module for Synergy'
      },
    ]
  }
}

oneview_logical_interconnect_group{'Logical Interconnect Group Edit':
  ensure  => 'present',
  require => Oneview_logical_interconnect_group['Puppet Ethernet LIG Synergy'],
  data    => {
    name     => 'Puppet Ethernet LIG Synergy',
    new_name => 'Edited LIG'
  }
}

oneview_logical_interconnect_group{'Logical Interconnect Group Found':
  ensure  => 'found',
  require => Oneview_logical_interconnect_group['Logical Interconnect Group Edit'],
  # data   => {
  #   name => 'Edited LIG'
  # }
}

oneview_logical_interconnect_group{'Logical Interconnect Group Get Default Settings':
  ensure  => 'get_default_settings',
  require => Oneview_logical_interconnect_group['Logical Interconnect Group Found'],
  data    => {
    name => 'Edited LIG'
  }
}

oneview_logical_interconnect_group{'Logical Interconnect Group Get Settings':
  ensure  => 'get_settings',
  require => Oneview_logical_interconnect_group['Logical Interconnect Group Get Default Settings'],
  data    => {
    name => 'Edited LIG'
  }
}

oneview_logical_interconnect_group{'Ethernet Logical Interconnect Group Destroy':
  ensure  => 'absent',
  require => Oneview_logical_interconnect_group['Logical Interconnect Group Get Settings'],
  data    => {
    name => 'Edited LIG'
  }
}


oneview_logical_interconnect_group{'FC Logical Interconnect Group Destroy':
  ensure  => 'absent',
  require => Oneview_logical_interconnect_group['Puppet FC LIG Synergy'],
  data    => {
    name => 'Puppet FC LIG Synergy'
  }
}
