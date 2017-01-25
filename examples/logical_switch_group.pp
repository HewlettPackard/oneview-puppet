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

oneview_logical_switch_group{'Logical Switch Group Create':
  ensure => 'present',
  data   =>
    {
      name     => 'OneViewSDK Test Logical Switch Group',
      category => 'logical-switch-groups',
      state    => 'Active',
      switches =>
      {
        number_of_switches => '2',
        type               => 'Cisco Nexus 50xx'
      }
    },
}

oneview_logical_switch_group{'Logical Switch Group Edit':
  ensure  => 'present',
  require => Oneview_logical_switch_group['Logical Switch Group Create'],
  data    =>
    {
      name     => 'OneViewSDK Test Logical Switch Group',
      new_name => 'OneViewSDK Logical Switch Group'
    }
}

oneview_logical_switch_group{'Logical Switch Group Found':
  ensure  => 'found',
  require => Oneview_logical_switch_group['Logical Switch Group Edit'],
  data    =>
    {
      name => 'OneViewSDK Logical Switch Group'
    }
}

oneview_logical_switch_group{'Logical Switch Group Get All':
  ensure => 'found'
  # data  =>
  #   {
  #     name => 'OneViewSDK Logical Switch Group'
  #   }
}

oneview_logical_switch_group{'Logical Switch Group Destroy':
  ensure  => 'absent',
  require => Oneview_logical_switch_group['Logical Switch Group Found'],
  data    =>
    {
      name => 'OneViewSDK Logical Switch Group'
    }
}
