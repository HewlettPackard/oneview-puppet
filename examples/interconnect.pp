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

oneview_interconnect{'Interconnect Get Types':
ensure => 'get_types'
}

oneview_interconnect{'Interconnect Found':
    ensure => 'found',
    data   => {
      name                  => 'Encl2, interconnect 1'
    }
}


oneview_interconnect{'Interconnect Get Type':
    ensure => 'get_interconnect_type',
    data   => {
      name                  => 'Encl2, interconnect 1'
    }
}

oneview_interconnect{'Interconnect Get Schema':
    ensure => 'get_schema',
    data   => {
      name                  => 'Encl2, interconnect 1',
    }
}

oneview_interconnect{'Interconnect Get Statistics':
    ensure => 'get_statistics',
    data   => {
      name                  => 'Encl2, interconnect 1',
    }
}

oneview_interconnect{'Interconnect Get Specific Statistics':
    ensure => 'get_statistics',
    data   => {
      name                  => 'Encl2, interconnect 1',
      subportStatistics     =>
      {
        portName => 'X8'
      }
    }
}

oneview_interconnect{'Interconnect Get Name Servers':
    ensure => 'get_name_servers',
    data   => {
      name                  => 'Encl2, interconnect 1'
    }
}

oneview_interconnect{'Interconnect Patch One Interconnect':
    ensure => 'present',
    data   => {
      name   => 'Encl2, interconnect 1',
      op     => 'replace',
      path   => '/uidState',
      value  => 'Off',
    }
}

oneview_interconnect{'Interconnect Patch All Interconnects':
    ensure => 'present',
    data   => {
      op     => 'replace',
      path   => '/powerState',
      value  => 'Off',
    }
}

oneview_interconnect{'Interconnect Destroy (warning)':
    ensure => 'absent',
    data   => {
      name                  => 'Encl2, interconnect 1'
    }
}

oneview_interconnect{'Interconnect Reset Port Protection':
    ensure => 'reset_port_protection',
    data   => {
      name  => 'Encl2, interconnect 1',
    }
}

oneview_interconnect{'Interconnect Update Ports':
    ensure => 'update_ports',
    data   => {
      name  => 'Encl2, interconnect 1',
      ports =>
      {
        d1 =>
        {
          portName => 'newPortName',
          available => 'false',
        },
        d2 =>
        {
          available => 'true',
        }
      },
    }
}
