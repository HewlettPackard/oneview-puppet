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

# NOTE: The names are not unique identifiers for this resource, but we highly suggest avoiding
# duplicate names for your san_managers in order to allow for updates using the names. This module will
# enforce name as a unique identifier for that reason.

oneview_san_manager{'san_manager_1':
    ensure => 'present',
    data   => {
      providerDisplayName => 'Brocade Network Advisor',
      connectionInfo      => [
      {
        name  => 'Host',
        value => '172.18.15.1'
      },
      {
        name  => 'Port',
        value => 5989
      },
      {
        name  => 'Username',
        value => 'dcs'
      },
      {
        name  => 'Password',
        value => 'dcs'
      },
      {
        name  => 'UseSsl',
        value => true
      }
      ],
    },
}

oneview_san_manager{'san_manager_2':
    ensure => 'present',
    data   => {
      providerDisplayName => 'Brocade Network Advisor',
      refreshState        => 'RefreshPending',
    },
}

oneview_san_manager{'san_manager_3':
    ensure => 'absent',
    data   => {
      providerDisplayName => 'Brocade Network Advisor'
    },
}
