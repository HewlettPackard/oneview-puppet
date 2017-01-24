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

# This resource is NOT supported if using the Synergy Hardware Variant

oneview_logical_switch{'Logical Switch Create':
  ensure => 'present',
  # SSH and SNMP credentials information per switch
  data   =>
  {
    name                  => 'Test Logical Switch',
    logicalSwitchGroupUri => 'OneViewSDK Logical Switch Group',
    switches              =>
    [
      {
        ip               => '172.18.16.91',
        ssh_username     => 'dcs',
        ssh_password     => 'dcs',
        snmp_port        => '161',
        community_string => 'admin'
      },
      {
        ip               => '172.18.16.92',
        ssh_username     => 'dcs',
        ssh_password     => 'dcs',
        snmp_port        => '161',
        community_string => 'admin'
      }
    ]
  }
}

oneview_logical_switch{'Logical Switch Found':
  ensure  => 'found'
}

oneview_logical_switch{'Logical Switch internal link set for specific logical switch':
  ensure => 'get_internal_link_sets',
  data   => {
    name => 'Test Logical Switch'
  }
}

oneview_logical_switch{'Logical Switch all internal link sets':
  ensure => 'get_internal_link_sets',
}

oneview_logical_switch{'Logical Switch Destroy':
  ensure  => 'absent',
  require => Oneview_logical_switch['Logical Switch Create'],
  data    =>
  {
    name                  => 'Test Logical Switch',
    logicalSwitchGroupUri => 'OneViewSDK Logical Switch Group'
  }
}

# This operation is not supported by all switch types
# oneview_logical_switch{'Logical Switch Refresh':
#   ensure           => 'refresh',
#   data             =>
#   {
#     name                  => 'Test Logical Switch',
#     logicalSwitchGroupUri => '1'
#   }
# }
