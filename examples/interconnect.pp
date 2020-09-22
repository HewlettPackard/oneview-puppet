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

oneview_interconnect{'Interconnect Get Types':
  ensure => 'get_types'
}

oneview_interconnect{'Interconnect Found':
  ensure => 'found',
  data   => {
    name => 'Encl1, interconnect 2',
  }
}

oneview_interconnect{'Interconnect Found All':
  ensure => 'found'
}

# Statistics filters are optional
oneview_interconnect{'Interconnect Get Specific Statistics':
  ensure => 'get_statistics',
  data   => {
    name  => 'Encl1, interconnect 2',
    statistics =>
    {
      portName => 'X1'
      # subportNumber => '1'
    }
  }
}

oneview_interconnect{'Interconnect Get Name Servers':
  ensure => 'get_name_servers',
  data   => {
    name => 'Encl1, interconnect 2'
  }
}

oneview_interconnect{'Interconnect Patch Interconnect':
  ensure => 'present',
  data   => {
    name  => 'Encl1, interconnect 2',
    patch =>
    {
      op    => 'replace',
      path  => '/uidState',
      value => 'Off'
    }
  }
}

oneview_interconnect{'Interconnect Reset Port Protection':
  ensure => 'reset_port_protection',
  data   => {
    name => 'Encl1, interconnect 2',
  }
}

# Each item in the array is a port to be updated
# The portName field needs to be declared, as it is the port identifier
oneview_interconnect{'Interconnect Update Ports':
  ensure => 'update_ports',
  data   =>
  {
    name  => 'Encl1, interconnect 2',
    ports =>
      [
        {
          portName => 'X1',
          enabled  => false
        },
        {
          portName => 'X2',
          enabled  => false
        }
      ]
  }
}

# The data and name filters are optional
oneview_interconnect{'Interconnect Get Link Topologies':
  ensure => 'get_link_topologies',
  data   => {
    name => 'name-1138866186-1483549608039',
  }
}
