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

# NOTE: Oneview does not change the name of Storage Systems. If one is listed incorrectly
  # on the creation/adding of the Storage System it may lead to issues. It should not be
  # used for updates at any given time.
# NOTE 2: Updating a storage_system requires both the ip_hostname and username to be listed inside
  # the credentials tag in data. If a password is also provided it will be updated.

oneview_storage_system{'storage_system_1':
    ensure => 'present',
    data   => {
      family      => 'StoreServ',
      hostname    => '<hostname>',
      credentials => {
        username => '<username>',
        password => '<password>',
      }
    }
}

oneview_storage_system{'storage_system_2':
    ensure  => 'present',
    require => Oneview_storage_system['storage_system_1'],
    data    => {
      family                   => 'StoreServ',
      hostname                 => '<hostname>',
      deviceSpecificAttributes => {
              managedDomain => 'TestDomain'
      },
      description              => 'Standard Description for Sample Purposes'
    }
}

oneview_storage_system{'storage_system_3':
    ensure  => 'found',
}

oneview_storage_system{'storage_system_4':
    ensure  => 'get_storage_pools',
    require => Oneview_storage_system['storage_system_3'],
    data    => {
      hostname   => '<hostname>'
    }
}

oneview_storage_system{'storage_system_6':
    ensure  => 'get_host_types',
}

oneview_storage_system{'storage_system_7':
    ensure => 'absent',
    data   => {
      hostname   => '<hostname>'
    }
}
