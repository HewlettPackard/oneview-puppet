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

oneview_logical_switch{'Logical Switch Create':
  ensure           => 'present',
  # SSH and SNMP credentials information
  ssh_username     => 'dcs',
  ssh_password     => 'dcs',
  snmp_port        => '161',
  community_string => 'public',
  switch1_ip       => '172.18.20.1',
  switch2_ip       => '172.18.20.2',
  data             =>
  {
    name                  => 'myds new',
    logicalSwitchGroupUri => '1',
  }
}

oneview_logical_switch{'Logical Switch Found':
  ensure  => 'found',
  require => Oneview_logical_switch['Logical Switch Create'],
  data    =>
  {
    name                  => 'myds new',
    logicalSwitchGroupUri => '1'
  }
}

oneview_logical_switch{'Logical Switch Get Schema':
  ensure  => 'get_schema',
  require => Oneview_logical_switch['Logical Switch Found'],
  data    =>
  {
    name                  => 'myds new',
    logicalSwitchGroupUri => '1'
  }
}

oneview_logical_switch{'Logical Switch Get All':
  ensure  => 'get_logical_switches',
  require => Oneview_logical_switch['Logical Switch Get Schema'],
}

oneview_logical_switch{'Logical Switch Destroy':
  ensure  => 'absent',
  require => Oneview_logical_switch['Logical Switch Get All'],
  data    =>
  {
    name                  => 'myds new',
    logicalSwitchGroupUri => '1'
  }
}

# This operation is not supported by this switch model
# oneview_logical_switch{'Logical Switch Refresh':
#   ensure           => 'refresh',
#   data             =>
#   {
#     name                  => 'myds new',
#     logicalSwitchGroupUri => '1'
#   }
# }
