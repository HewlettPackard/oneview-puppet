################################################################################
# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
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

# NOTE: As with all resources, the found ensurable accepts a data as an optional filter field.
oneview_hypervisor_manager{'hm1':
    ensure => 'present',
    data   => {
      name     => '172.18.1.13',
      username => 'dcs',
      password => 'dcs'
    }
}

oneview_hypervisor_manager{'hm2':
    ensure  => 'present',
    require => oneview_hypervisor_manager['hm1'],
    data    => {
      name     => '172.18.1.13',
      new_name => '172.18.1.14'
    }
}

oneview_hypervisor_manager{'hm3':
    ensure  => 'found',
    require => oneview_hypervisor_manager['hm2'],
    data    => {
      name     => '172.18.1.13',
      username => 'dcs',
      password => 'dcs'
    }
}

oneview_hypervisor_manager{'hm4':
    ensure  => 'absent',
    require => oneview_hypervisor_manager['hm3'],
    data    => {
      name     => '172.18.1.13',
      username => 'dcs',
      password => 'dcs'
    }
}
