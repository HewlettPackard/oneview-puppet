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

# The Interconnects and Uplink Sets can also be declared as follows:
oneview_sas_logical_interconnect_group{'Puppet SAS LIG':
  ensure => 'present',
  data   => {
    name          => 'Puppet SAS LIG',
    interconnects =>
    [
      {
        bay  => 1,
        type => 'Synergy 12Gb SAS Connection Module'
      },
      {
        bay  => 4,
        type => 'Synergy 12Gb SAS Connection Module'
      },
    ]
  }
}

oneview_sas_logical_interconnect_group{'Logical Interconnect Group Edit':
  ensure  => 'present',
  require => Oneview_sas_logical_interconnect_group['Puppet SAS LIG'],
  data    => {
    name     => 'Puppet SAS LIG',
    new_name => 'Edited LIG'
  }
}

oneview_sas_logical_interconnect_group{'Logical Interconnect Group Found':
  ensure  => 'found',
  require => Oneview_sas_logical_interconnect_group['Logical Interconnect Group Edit'],
}

oneview_sas_logical_interconnect_group{'Logical Interconnect Group Destroy':
  ensure  => 'absent',
  require => Oneview_sas_logical_interconnect_group['Puppet SAS LIG'],
  data    => {
    name => 'Edited LIG'
  }
}
