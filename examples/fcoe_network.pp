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

oneview_fcoe_network{'FCoE Create':
  ensure => 'present',
  data   => {
    name                  => 'FCoE Network',
    vlanId                => '1000',
    connectionTemplateUri => nil,
  }
}

oneview_fcoe_network{'FCoE Update':
  ensure  => 'present',
  require => Oneview_fcoe_network['FCoE Create'],
  data    => {
    name     => 'FCoE Network',
    new_name => 'New FCoE Network Name'
  }
}

oneview_fcoe_network{'FCoE Found':
  ensure  => 'found',
  require => Oneview_fcoe_network['FCoE Update'],
  data    => {
    vlanId => '1000'
  }
}


oneview_fcoe_network{'FCoE Delete':
  ensure  => 'absent',
  require => Oneview_fcoe_network['FCoE Found'],
  data    => {
    name => 'New FCoE Network Name'
  }
}
